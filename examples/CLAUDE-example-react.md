# React E-commerce Frontend - Claude Context

## Project Overview
Modern e-commerce frontend built with React, TypeScript, and Tailwind CSS. Connects to FastAPI backend.

## Technology Stack
- **Framework**: React 18.2 with TypeScript 5.0
- **Styling**: Tailwind CSS 3.4 
- **State**: Zustand for global, React Query for server
- **Forms**: React Hook Form + Zod
- **Testing**: Vitest + React Testing Library
- **Build**: Vite 5.0

## Project Structure
```
src/
├── components/     # Reusable UI components
│   ├── common/    # Button, Input, Modal, etc.
│   └── features/  # ProductCard, CartItem, etc.
├── pages/         # Route components
├── hooks/         # Custom React hooks
├── services/      # API calls and external services
├── stores/        # Zustand stores
├── types/         # TypeScript type definitions
└── utils/         # Helper functions
```

## How Claude Should Use This Document

### Code Generation Rules
1. **Always use TypeScript** - no `any` types unless absolutely necessary
2. **Follow component patterns** - see examples below
3. **Use existing utilities** - check `utils/` before creating new helpers
4. **Maintain consistency** - match imports, naming, and structure

### When I Ask You To:
- **"Add a feature"** - Create component in correct directory, add types, write tests
- **"Fix a bug"** - Check error boundaries, validate props, handle edge cases
- **"Refactor"** - Maintain functionality, improve readability, add comments
- **"Review"** - Check types, test coverage, accessibility, performance

### Response Format
```typescript
// 1. Show file path
// src/components/features/ProductCard.tsx

// 2. Include all imports
import { FC } from 'react';
import { Product } from '@/types';

// 3. Add JSDoc for complex components
/**
 * Displays product information in a card layout
 */

// 4. Use proper typing
interface ProductCardProps {
  product: Product;
  onAddToCart: (id: string) => void;
}
```

## Current Development Standards

### Component Pattern
```typescript
// ✅ Good - Functional component with proper types
export const ProductCard: FC<ProductCardProps> = ({ product, onAddToCart }) => {
  const { id, name, price, image } = product;
  
  return (
    <article className="rounded-lg border p-4 hover:shadow-lg transition-shadow">
      <img src={image} alt={name} className="w-full h-48 object-cover rounded" />
      <h3 className="mt-2 font-semibold">{name}</h3>
      <p className="text-gray-600">${price.toFixed(2)}</p>
      <button 
        onClick={() => onAddToCart(id)}
        className="mt-2 w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700"
      >
        Add to Cart
      </button>
    </article>
  );
};

// ❌ Bad - Class component, no types, inline styles
class ProductCard extends React.Component {
  render() {
    return <div style={{border: '1px solid black'}}>{this.props.name}</div>
  }
}
```

### API Calls Pattern
```typescript
// services/products.ts
export const productService = {
  async getAll(): Promise<Product[]> {
    const response = await api.get('/products');
    return response.data;
  },
  
  async getById(id: string): Promise<Product> {
    const response = await api.get(`/products/${id}`);
    return response.data;
  }
};

// hooks/useProducts.ts
export const useProducts = () => {
  return useQuery({
    queryKey: ['products'],
    queryFn: productService.getAll,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};
```

### State Management Pattern
```typescript
// stores/cartStore.ts
interface CartState {
  items: CartItem[];
  addItem: (product: Product) => void;
  removeItem: (id: string) => void;
  clearCart: () => void;
  total: number;
}

export const useCartStore = create<CartState>((set, get) => ({
  items: [],
  
  addItem: (product) => set((state) => {
    const existingItem = state.items.find(item => item.id === product.id);
    if (existingItem) {
      return {
        items: state.items.map(item =>
          item.id === product.id 
            ? { ...item, quantity: item.quantity + 1 }
            : item
        )
      };
    }
    return { items: [...state.items, { ...product, quantity: 1 }] };
  }),
  
  removeItem: (id) => set((state) => ({
    items: state.items.filter(item => item.id !== id)
  })),
  
  clearCart: () => set({ items: [] }),
  
  get total() {
    return get().items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  }
}));
```

## Current Focus
Building checkout flow:
- [x] Cart summary component
- [x] Shipping address form
- [ ] Payment integration (Stripe)
- [ ] Order confirmation page

## Common Commands
```bash
# Development
npm run dev          # Start dev server on :5173
npm run build        # Build for production
npm run preview      # Preview production build

# Testing
npm test            # Run tests in watch mode
npm run test:ci     # Single test run with coverage

# Code Quality
npm run lint        # ESLint check
npm run format      # Prettier format
npm run typecheck   # TypeScript check
```

## Key Conventions

### File Naming
- Components: `PascalCase.tsx` (e.g., `ProductCard.tsx`)
- Hooks: `camelCase.ts` starting with `use` (e.g., `useProducts.ts`)
- Utils: `camelCase.ts` (e.g., `formatPrice.ts`)
- Types: `PascalCase.ts` (e.g., `Product.ts`)

### Import Order
1. React imports
2. Third-party libraries
3. Absolute imports (@/)
4. Relative imports
5. Types
6. Styles

### Testing Requirements
- Component tests: User interactions and rendering
- Hook tests: State changes and side effects
- Min 80% coverage for new features
- Use `data-testid` for test selectors

## Performance Guidelines
- Lazy load routes with `React.lazy`
- Memoize expensive computations
- Use `React.memo` for pure components
- Implement virtual scrolling for long lists
- Optimize images (WebP, lazy loading)

## Accessibility Standards
- Semantic HTML elements
- ARIA labels for interactive elements
- Keyboard navigation support
- Focus management in modals
- Color contrast WCAG AA compliant

## Claude Instructions for This Project

### Do's
- ✅ Use TypeScript strictly
- ✅ Follow established patterns
- ✅ Write tests for new features
- ✅ Handle loading and error states
- ✅ Validate forms with Zod schemas
- ✅ Use Tailwind classes, avoid inline styles
- ✅ Comment complex logic
- ✅ Check for existing implementations

### Don'ts
- ❌ Don't use `any` type
- ❌ Don't create global styles
- ❌ Don't ignore error boundaries
- ❌ Don't skip accessibility
- ❌ Don't use deprecated APIs
- ❌ Don't mutate state directly

### When Generating Code
1. Start with types/interfaces
2. Implement component/function
3. Add error handling
4. Write tests
5. Update documentation

### Example Task Response
When asked to "Add product filtering":
1. Define filter types in `types/Filter.ts`
2. Create `useProductFilters` hook
3. Build `ProductFilters` component
4. Update `ProductList` to use filters
5. Add tests for filtering logic
6. Document filter options

---
*Last Updated: 2025-01-17*
*Next Review: When payment integration is complete*