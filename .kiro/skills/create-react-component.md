# Skill: Create React Component

## When to use
When asked to create a new React UI component, page, or form.

## Steps

1. Create file in `/src/components/` (reusable) or `/src/pages/` (route-level)
2. Define TypeScript props interface
3. Implement functional component
4. Add CSS Module or Tailwind classes for styling
5. Export as default
6. If it fetches data, use React Query `useQuery` hook via a service function

## Component Template

```tsx
// {ComponentName}.tsx
import styles from './{ComponentName}.module.css'; // if using CSS Modules

interface {ComponentName}Props {
  // define props here
}

export default function {ComponentName}({ /* props */ }: {ComponentName}Props) {
  return (
    <div className={styles.container}>
      {/* content */}
    </div>
  );
}
```

## Data-Fetching Component Template

```tsx
import { useQuery } from '@tanstack/react-query';
import { get{Entity} } from '@/services/{entity}Service';

interface {ComponentName}Props {
  id: number;
}

export default function {ComponentName}({ id }: {ComponentName}Props) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['{entity}', id],
    queryFn: () => get{Entity}(id),
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading data.</div>;

  return (
    <div>
      {/* render data */}
    </div>
  );
}
```

## Service Template

```ts
// /src/services/{entity}Service.ts
import apiClient from './apiClient';

export async function get{Entity}(id: number) {
  const { data } = await apiClient.get(`/{entity}/${id}`);
  return data;
}

export async function create{Entity}(payload: Create{Entity}Request) {
  const { data } = await apiClient.post('/{entity}', payload);
  return data;
}
```

## Related Steering

- #[[file:.kiro/steering/react-standards.md]]
- #[[file:.kiro/steering/project-overview.md]]
