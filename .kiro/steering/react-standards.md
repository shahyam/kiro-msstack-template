---
inclusion: fileMatch
fileMatchPattern: "**/*.tsx,**/*.ts"
---

# React JS Coding Standards

## General

- Use Vite as the build tool and dev server (`npm create vite@latest`)
- Use functional components with hooks — no class components
- TypeScript preferred for all new components
- One component per file; filename matches component name (PascalCase)
- Keep components small and focused (single responsibility)

## Vite

- Use `vite.config.ts` for configuration
- Use `@` path alias mapped to `/src` for clean imports
- Use `.env`, `.env.development`, `.env.production` for environment variables
- All env vars must be prefixed with `VITE_` to be exposed to the client
- Use `vite-plugin-react` (with SWC) for fast refresh: `@vitejs/plugin-react-swc`

```ts
// ✅ vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') }, // enables @/components/...
  },
});

// ✅ .env.development
// VITE_API_BASE_URL=https://localhost:7001/api

// ✅ Usage in code
// const apiUrl = import.meta.env.VITE_API_BASE_URL;

// ❌ Bad — secret in VITE_ var (exposed to browser bundle)
// VITE_DB_PASSWORD=secret123
```

## Project Structure

```
/src
  /components     - Reusable UI components
  /pages          - Route-level page components
  /hooks          - Custom hooks (use* prefix)
  /services       - API call functions
  /store          - State management (Redux / Zustand / Context)
  /types          - TypeScript interfaces and types
  /utils          - Helper functions
  /assets         - Images, fonts, static files
```

## Hooks & State

- Use `useState`, `useEffect`, `useCallback`, `useMemo` appropriately
- Extract complex logic into custom hooks
- Avoid prop drilling — use Context or state management for shared state
- Clean up side effects in `useEffect` return function

```tsx
// ✅ Good — custom hook extracts logic, cleanup in useEffect
function useOrderStatus(orderId: number) {
  const [status, setStatus] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    fetchOrderStatus(orderId, controller.signal).then(setStatus);

    return () => controller.abort(); // ✅ cleanup cancels in-flight request
  }, [orderId]);

  return status;
}

// ❌ Bad — logic inline in component, no cleanup
function OrderPage({ orderId }: { orderId: number }) {
  const [status, setStatus] = useState(null);
  useEffect(() => {
    fetch(`/api/orders/${orderId}`).then(r => r.json()).then(d => setStatus(d.status));
    // ❌ no cleanup, no dependency array discipline
  });
}
```

## API Calls

- Centralize all API calls in `/services`
- Use `axios` or `fetch` with a base client configured with interceptors
- Handle loading, error, and success states explicitly
- Use React Query or SWR for server state management

```ts
// ✅ Good — base client with interceptor in /services/apiClient.ts
import axios from 'axios';

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  withCredentials: true,
});

apiClient.interceptors.response.use(
  res => res,
  err => {
    if (err.response?.status === 401) window.location.href = '/login';
    return Promise.reject(err);
  }
);

export default apiClient;

// ✅ Good — service function in /services/orderService.ts
export async function getOrder(id: number): Promise<OrderResponse> {
  const { data } = await apiClient.get<OrderResponse>(`/orders/${id}`);
  return data;
}

// ✅ Good — React Query usage in component
const { data, isLoading, error } = useQuery({
  queryKey: ['order', id],
  queryFn: () => getOrder(id),
});

// ❌ Bad — fetch directly in component
useEffect(() => {
  fetch(`/api/orders/${id}`).then(...); // ❌ no base client, no error handling
}, []);
```

## TypeScript

- Define interfaces for all props, API responses, and state shapes
- Avoid `any` — use `unknown` and narrow types
- Use `type` for unions/intersections, `interface` for object shapes

```ts
// ✅ Good
interface OrderResponse {
  id: number;
  reference: string;
  total: number;
}

type OrderStatus = 'pending' | 'confirmed' | 'cancelled'; // union → type

interface OrderCardProps {
  order: OrderResponse;
  onCancel: (id: number) => void;
}

// ❌ Bad
const handleResponse = (data: any) => { ... }; // ❌ any kills type safety
```

## Performance

- Memoize expensive computations with `useMemo`
- Memoize callbacks passed to child components with `useCallback`
- Use `React.lazy` and `Suspense` for code splitting on routes
- Avoid unnecessary re-renders — profile with React DevTools

## Testing

- Use Vitest (built-in Vite integration) + React Testing Library
- Test behavior, not implementation details
- Mock API calls using MSW (Mock Service Worker)
- Unit tests required for all hooks, services, and utility functions
- Place test files alongside source: `{Component}.test.tsx`

## Accessibility (a11y)

- Use semantic HTML: `<button>`, `<nav>`, `<main>`, `<header>` instead of `<div role="button">`
- Include descriptive `aria-label` or `aria-labelledby` on interactive elements without visible text
- Ensure all form inputs have associated `<label>` elements
- Use `aria-required`, `aria-invalid`, `aria-describedby` for form validation feedback
- Maintain minimum color contrast ratio of 4.5:1 for text (WCAG AA standard)
- Implement keyboard navigation — all interactive elements accessible via Tab, Enter, Space, Escape
- Use `aria-live` regions for dynamic content updates
- Include skip-to-main-content link at top of page
- Test with screen readers (NVDA, JAWS) and accessibility tools (axe, Lighthouse)

```tsx
// ✅ Good — semantic HTML, labels, ARIA labels, color contrast
function OrderForm() {
  const [errors, setErrors] = useState<Record<string, string>>({});

  return (
    <main className="order-form">
      <h1>Place Your Order</h1>
      <form aria-label="Order form">
        <div className="form-group">
          <label htmlFor="customer-name">Customer Name</label>
          <input
            id="customer-name"
            type="text"
            aria-required="true"
            aria-invalid={!!errors.name}
            aria-describedby={errors.name ? "name-error" : undefined}
          />
          {errors.name && (
            <span id="name-error" className="error" role="alert">
              {errors.name}
            </span>
          )}
        </div>
        <button type="submit" className="btn-primary">Submit Order</button>
      </form>
    </main>
  );
}

// ❌ Bad — no semantic HTML, no labels, no ARIA, divs for buttons
function OrderForm() {
  return (
    <div>
      <div>Place Your Order</div>
      <div>
        <div>Customer Name</div>
        <input type="text" /> {/* ❌ no label, no aria-required */}
      </div>
      <div className="btn" onClick={submit}>Submit</div> {/* ❌ not a button */}
    </div>
  );
}
```

## Performance

- Use `React.memo` to prevent unnecessary re-renders of expensive components
- Use `useMemo` for expensive computations — memoize dependent values
- Use `useCallback` for callbacks passed to memoized child components
- Implement code splitting with `React.lazy` and `Suspense` on route pages
- Use React DevTools Profiler to identify and fix performance bottlenecks
- Lazy-load images with `loading="lazy"` or intersection observer
- Avoid creating objects/arrays in component body — move to module level or useMemo

```tsx
// ✅ Good — memo, useCallback, useMemo
interface OrderListProps {
  orders: OrderResponse[];
  onSelectOrder: (id: number) => void;
}

function OrderListItem({ order, onSelectOrder }: OrderListProps['orders'][0] & { onSelectOrder: (id: number) => void }) {
  const handleClick = useCallback(() => onSelectOrder(order.id), [order.id, onSelectOrder]);
  return <div onClick={handleClick}>{order.id}</div>;
}

const MemoizedOrderListItem = React.memo(OrderListItem);

function OrderList({ orders, onSelectOrder }: OrderListProps) {
  const memoizedHandler = useCallback(onSelectOrder, [onSelectOrder]);
  const expensiveValue = useMemo(() => orders.filter(o => o.total > 1000), [orders]);

  return (
    <div>
      {expensiveValue.map(order => (
        <MemoizedOrderListItem
          key={order.id}
          order={order}
          onSelectOrder={memoizedHandler}
        />
      ))}
    </div>
  );
}

// ❌ Bad — no memoization, inline objects, no optimization
function OrderList({ orders, onSelectOrder }) {
  return (
    <div>
      {orders.map(order => (
        <OrderListItem
          key={order.id}
          order={order}
          onSelectOrder={() => onSelectOrder(order.id)} // ❌ new function every render
        />
      ))}
    </div>
  );
}
```

## Security

- Never store sensitive data (tokens, secrets, PII) in localStorage
- Sanitize HTML if rendering user-generated content — use `DOMPurify` library
- Validate all API responses — never trust the server blindly
- Use Content Security Policy (CSP) headers to prevent XSS attacks
- Implement secure dependencies — use `npm audit` and keep packages updated
- Never expose environment variables or API keys in bundle — use backend proxies for sensitive endpoints

```ts
// ✅ Good — tokens in httpOnly cookies, XSS prevention
// API calls use httpOnly cookies automatically (withCredentials: true)
export async function loginUser(username: string, password: string) {
  const response = await apiClient.post('/auth/login', { username, password });
  // Token stored in httpOnly cookie by server, not accessible to JS
  return response.data;
}

// ✅ Good — sanitize before rendering
import DOMPurify from 'dompurify';

function UserComment({ html }: { html: string }) {
  return <div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(html) }} />;
}

// ❌ Bad — token in localStorage, exposed to XSS
localStorage.setItem('authToken', response.data.token); // ❌ vulnerable

// ❌ Bad — raw user HTML
function UserComment({ html }: { html: string }) {
  return <div dangerouslySetInnerHTML={{ __html: html }} />; // ❌ XSS risk
}
```
