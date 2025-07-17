# How to Use CLAUDE.md with Claude Code

## What is CLAUDE.md?

CLAUDE.md is a special context file that Claude Code automatically reads when you start working in a project. It provides Claude with essential information about your project, coding standards, and preferences.

## How Claude Code Uses CLAUDE.md

1. **Automatic Detection**: Claude Code looks for `CLAUDE.md` in:
   - Current working directory
   - Project root (if in a subdirectory)
   - `.claude/` directory

2. **Context Loading**: The content is loaded as initial context, helping Claude understand:
   - Project structure and architecture
   - Coding conventions and standards
   - Current development focus
   - Common commands and workflows

## Creating CLAUDE.md

### Quick Start
```bash
# In your project directory
claude-init  # Creates CLAUDE.md from template
```

### Manual Creation
```bash
# Copy template manually
cp ~/dotfiles/templates/CLAUDE.md .

# Or create from scratch
touch CLAUDE.md
```

## Best Practices

### 1. Keep It Focused
- Include only relevant information
- Update regularly as project evolves
- Remove outdated sections

### 2. Structure for Clarity
```markdown
# Project Context for Claude Code

## Overview
Brief description in 2-3 sentences

## Tech Stack
- Language: Python 3.11
- Framework: FastAPI
- Database: PostgreSQL

## Current Task
Working on user authentication system
```

### 3. Include Examples
```markdown
## Code Style
# Good
def calculate_total(items: List[Item]) -> Decimal:
    return sum(item.price for item in items)

# Avoid
def calc(i):
    t = 0
    for x in i: t += x.price
    return t
```

### 4. Common Commands
```markdown
## Commands
- Run tests: `pytest -v`
- Start dev: `make dev`
- Deploy: `./deploy.sh production`
```

## What to Include

### Essential Information
- ✅ Project purpose and goals
- ✅ Technology stack
- ✅ Project structure
- ✅ Coding conventions
- ✅ Current development focus

### Helpful Additions
- ✅ Common commands
- ✅ API endpoints/schemas
- ✅ Testing approach
- ✅ Known issues/limitations
- ✅ Performance considerations

### What NOT to Include
- ❌ Sensitive information (passwords, API keys)
- ❌ Large code dumps
- ❌ Outdated information
- ❌ Generic programming tutorials

## Advanced Usage

### Project-Specific Instructions
```markdown
## Claude Instructions
- Always use type hints
- Prefer composition over inheritance
- Write tests for new features
- Follow REST API conventions
- Use async/await for I/O operations
```

### Multi-Module Projects
```markdown
## Module Overview
- `api/` - FastAPI application
- `core/` - Business logic
- `db/` - Database models
- `tasks/` - Background jobs

When working in `api/`, focus on request/response models.
When in `core/`, ensure pure functions without side effects.
```

### Context for Different Phases
```markdown
## Development Phase: MVP
Currently building core features:
- User registration ✓
- Authentication ✓
- Profile management (in progress)
- Payment integration (next)

Focus on functionality over optimization.
```

## Tips for Effective CLAUDE.md

1. **Update Regularly**
   ```bash
   # After major changes
   vim CLAUDE.md  # Update current focus
   ```

2. **Use Sections Claude Can Reference**
   ```markdown
   ## Database Schema
   See `docs/schema.sql` for full schema
   
   ## API Documentation  
   Run `make docs` to generate
   ```

3. **Include Debugging Hints**
   ```markdown
   ## Common Issues
   - If tests fail: check DATABASE_URL
   - Slow queries: run EXPLAIN ANALYZE
   - Import errors: verify virtual env
   ```

4. **Version Control**
   ```bash
   # Always commit CLAUDE.md
   git add CLAUDE.md
   git commit -m "Update Claude context"
   ```

## Example: Full CLAUDE.md

```markdown
# E-commerce API Context

## Overview
REST API for online marketplace using FastAPI and PostgreSQL.

## Tech Stack
- Python 3.11 with FastAPI
- PostgreSQL 14 with asyncpg
- Redis for caching
- Docker for deployment

## Project Structure
```
api/
├── app/
│   ├── api/       # Endpoints
│   ├── core/      # Config, security
│   ├── crud/      # Database operations
│   ├── models/    # SQLAlchemy models
│   └── schemas/   # Pydantic models
├── tests/
└── alembic/       # Migrations
```

## Current Focus
Implementing product search with filters:
- Text search using PostgreSQL FTS
- Category/price/rating filters
- Pagination with cursor

## Coding Standards
- Type hints required
- Async/await for all I/O
- Pydantic for validation
- 100% test coverage for new code

## Common Commands
```bash
# Development
make dev          # Start with hot reload
make test         # Run tests with coverage
make lint         # Format and lint

# Database
make migrate      # Apply migrations
make seed         # Load sample data
```

## API Patterns
All endpoints follow:
- `/api/v1/{resource}`
- Pagination: `?limit=20&cursor=xxx`
- Filtering: `?category=electronics&min_price=10`
- Sorting: `?sort=-created_at`

## Performance Notes
- Use select_related() for joins
- Cache expensive queries in Redis
- Batch operations when possible

## Claude Instructions
- Follow existing patterns in codebase
- Write tests alongside implementation
- Use meaningful variable names
- Add docstrings for complex logic
- Validate all user input
```

## Troubleshooting

### CLAUDE.md Not Being Read
1. Check file location (must be in project root)
2. Verify file name (case-sensitive)
3. Ensure no syntax errors in markdown

### Too Much Context
- Keep under 2000 lines
- Focus on current work
- Link to detailed docs instead

### Outdated Information
- Review weekly
- Update after major changes
- Remove completed tasks

## Integration with Workflow

1. **Start New Feature**
   ```bash
   # Update CLAUDE.md with new focus
   vim CLAUDE.md
   # Start Claude Code
   claude chat
   ```

2. **Debug Session**
   ```markdown
   ## Current Issue
   API returns 500 on POST /products
   Error: "column price cannot be null"
   Suspect: Schema validation mismatch
   ```

3. **Code Review**
   ```markdown
   ## Review Focus
   - Check SQL injection vulnerabilities
   - Verify proper error handling
   - Ensure consistent API responses
   ```

Remember: CLAUDE.md is your communication channel with Claude. Keep it clear, current, and focused on what matters for your project!