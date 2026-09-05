# Agent Routing Registry

Adaptive routing lookup for Claude Code agent selection. Organized by domain with routing signals, model tiers, and disambiguation rules.

**Model tiers:** `haiku` = scan/audit/light tasks, `sonnet` = standard implementation, `opus` = architecture/high-stakes, `inherit` = pipeline stages that use parent's model.

---

## Quick Routing Decision Tree

```
1. Is this a RESEARCH task?
   ├─ Web/market analysis → research-analyst | market-researcher | competitive-analyst
   ├─ Scientific papers → scientific-literature-researcher
   ├─ Data gathering → data-researcher | search-specialist
   └─ Full pipeline → ai-manager (orchestrates researcher → critical → creative → post-mortem → documenter)

2. Is this IMPLEMENTATION work?
   ├─ Which layer?
   │  ├─ Frontend only → frontend-developer (multi-framework) or framework-specific agent
   │  ├─ Backend only → backend-developer or framework-specific agent
   │  ├─ Full-stack feature → fullstack-developer
   │  └─ Database → sql-pro | postgres-pro | database-administrator | database-optimizer
   ├─ Which language/framework? → see Language-Specific section
   └─ What kind of system? → see Infrastructure/DevOps or Security sections

3. Is this ARCHITECTURE/REVIEW?
   ├─ System design → architect-reviewer | microservices-architect | cloud-architect
   ├─ Code review → code-reviewer
   └─ Design evaluation → architect-reviewer

4. Is this a PIPELINE/WORKFLOW task?
   ├─ CI/CD → deployment-engineer | build-engineer
   ├─ Infrastructure → terraform-engineer | docker-expert | kubernetes-specialist
   └─ Monitoring → performance-monitor | sre-engineer

5. Is this QUALITY/SECURITY?
   ├─ Testing → test-automator | qa-expert | accessibility-tester
   ├─ Security audit → security-auditor | penetration-tester | compliance-auditor
   └─ Performance → performance-engineer | database-optimizer

6. Is this DOCUMENTATION?
   ├─ API docs → api-documenter | documentation-engineer
   ├─ Technical writing → technical-writer
   └─ README → readme-generator

7. Is this a NON-CODING domain?
   ├─ Business → business-analyst | product-manager | project-manager
   ├─ Legal → legal-advisor | license-engineer
   ├─ Marketing → content-marketer | seo-specialist
   └─ UX → ui-designer | ux-researcher
```

---

## Frontend & UI

| Agent | Model | Signals (route when you hear...) | Notes |
|-------|-------|----------------------------------|-------|
| `frontend-developer` | sonnet | "frontend", "UI", "build a web app", "React/Vue/Angular" | Multi-framework generalist. Use when framework is unspecified or mixed. |
| `react-specialist` | sonnet | "React", "React 18", "hooks", "state management", "Redux" | Deep React optimization, not general frontend. |
| `nextjs-developer` | sonnet | "Next.js", "App Router", "SSR", "server components", "SSG" | Full-stack Next.js, not just React. |
| `angular-architect` | sonnet | "Angular", "RxJS", "NgRx", "Angular 15+" | Enterprise Angular specifically. |
| `vue-expert` | sonnet | "Vue", "Vue 3", "Composition API", "Nuxt" | Vue/Nuxt specialist. |
| `typescript-pro` | sonnet | "TypeScript", "generics", "type system", "advanced types" | Cross-cutting; use with any agent when TS complexity is the core issue. |
| `javascript-pro` | sonnet | "JavaScript", "ES2023", "Node.js", "vanilla JS" | Pure JS without framework specificity. |
| `ui-designer` | sonnet | "design system", "component library", "visual design", "Figma" | Design-oriented, not implementation. Pair with frontend-developer for build. |
| `design-bridge` | opus | "DESIGN.md", "replicate design", "VoltAgent design" | Converts design specs to code. |
| `electron-pro` | sonnet | "Electron", "desktop app", "native OS integration" | Desktop apps with Electron. |
| `expo-react-native-expert` | sonnet | "Expo", "React Native", "OTA updates", "App Store" | Expo RN specifically. |

**Disambiguation:**
- "Build a React dashboard" → `react-specialist` (React-specific optimization)
- "Build a frontend, not sure on framework" → `frontend-developer` (broad coverage)
- "Migrate our Angular app to React" → `frontend-developer` (multi-framework expertise)

---

## Backend & APIs

| Agent | Model | Signals | Notes |
|-------|-------|---------|-------|
| `backend-developer` | sonnet | "API", "REST", "microservice", "server-side", "backend" | General backend. Use when no specific framework mentioned. |
| `fullstack-developer` | sonnet | "full-stack feature", "end to end", "DB to UI", "complete feature" | Spans all layers. Prefer over combining frontend + backend agents. |
| `api-designer` | sonnet | "design API", "OpenAPI", "API spec", "REST endpoint" | Design/spec phase, not implementation. |
| `api-documenter` | haiku | "document API", "API docs", "Swagger" | Documentation only, read-heavy. |
| `graphql-architect` | opus | "GraphQL", "federation", "schema", "Apollo" | GraphQL-specific architecture. |
| `websocket-engineer` | sonnet | "WebSocket", "real-time", "Socket.IO", "bidirectional" | Real-time communication. |
| `payment-integration` | opus | "payment", "Stripe", "checkout", "PCI", "transaction" | High-stakes financial integrations. |
| `fintech-engineer` | opus | "financial", "compliance", "banking", "trading platform" | Broader financial systems. |

---

## Language & Framework Specialists

### TypeScript / JavaScript
| Agent | Signals | When to prefer over `backend-developer` |
|-------|---------|----------------------------------------|
| `typescript-pro` | "TypeScript types", "generics", "type-level" | Type system complexity is the core challenge |
| `javascript-pro` | "vanilla JS", "ES2023", "Node.js patterns" | No framework in play, pure JS |

### Python
| Agent | Model | Signals |
|-------|-------|---------|
| `python-pro` | sonnet | "Python", "type hints", "async", "production Python" |
| `fastapi-developer` | sonnet | "FastAPI", "Pydantic", "async API", "ASGI" |
| `django-developer` | sonnet | "Django", "Django REST", "Django 4+" |
| `data-scientist` | sonnet | "data analysis", "pandas", "statistics", "modeling" |
| `data-engineer` | sonnet | "data pipeline", "ETL", "ELT", "data platform" |
| `nlp-engineer` | sonnet | "NLP", "text processing", "language model", "NER", "sentiment" |
| `ml-engineer` | sonnet | "ML training", "model serving", "pipeline" |
| `mlops-engineer` | sonnet | "ML infrastructure", "model versioning", "experiment tracking" |
| `reinforcement-learning-engineer` | sonnet | "RL", "reward optimization", "policy gradient", "Q-learning" |

### Go
| Agent | Signals |
|-------|---------|
| `golang-pro` | "Go", "goroutine", "channel", "concurrent", "Go microservice" |

### Rust
| Agent | Signals |
|-------|---------|
| `rust-engineer` | "Rust", "ownership", "lifetime", "zero-cost", "memory safety" |

### Java / JVM
| Agent | Signals |
|-------|---------|
| `java-architect` | "Java", "Spring Boot", "microservice Java", "enterprise Java" |
| `spring-boot-engineer` | "Spring Boot 3", "Spring WebFlux", "Spring Cloud" |
| `kotlin-specialist` | "Kotlin", "coroutine", "Kotlin multiplatform", "Jetpack Compose" |
| `elixir-expert` | "Elixir", "Phoenix", "OTP", "GenServer", "BEAM" |

### .NET
| Agent | Signals |
|-------|---------|
| `csharp-developer` | "C#", "ASP.NET Core", ".NET", "Entity Framework" |
| `dotnet-core-expert` | ".NET Core", "cloud-native .NET", "minimal API" |
| `dotnet-framework-4.8-expert` | ".NET Framework 4.8", "legacy .NET", "WCF", "WebForms" |

### PHP
| Agent | Signals |
|-------|---------|
| `php-pro` | "PHP 8.3", "strict typing PHP", "modern PHP" |
| `laravel-specialist` | "Laravel", "Eloquent", "Laravel 10+", "Horizon" |
| `symfony-specialist` | "Symfony", "Doctrine ORM", "Messenger" |

### Ruby
| Agent | Signals |
|-------|---------|
| `rails-expert` | "Rails", "Hotwire", "ActionCable", "Rails 7/8" |

### C/C++
| Agent | Signals |
|-------|---------|
| `cpp-pro` | "C++", "C++20/23", "template", "embedded C++", "systems programming" |
| `embedded-systems` | "firmware", "RTOS", "microcontroller", "real-time" |

### Swift
| Agent | Signals |
|-------|---------|
| `swift-expert` | "Swift", "SwiftUI", "iOS", "macOS", "actor" |

### Mobile
| Agent | Model | Signals |
|-------|-------|---------|
| `mobile-developer` | sonnet | "cross-platform mobile", "React Native/Flutter", "offline-first" |
| `mobile-app-developer` | sonnet | "iOS/Android", "native performance", "mobile deployment" |
| `flutter-expert` | sonnet | "Flutter 3+", "Dart", "cross-platform UI" |
| `expo-react-native-expert` | sonnet | "Expo", "React Native", "OTA" |
| `kotlin-specialist` | sonnet | "Kotlin Android", "Jetpack Compose" |

### Other Languages / Frameworks
| Agent | Signals |
|-------|---------|
| `wordpress-master` | "WordPress", "WooCommerce", "WordPress plugin/theme" |
| `game-developer` | "game", "Unity", "Unreal", "rendering", "multiplayer game" |
| `blockchain-developer` | "Solidity", "smart contract", "DApp", "Web3", "gas optimization" |

---

## Database

| Agent | Model | Signals | Disambiguation |
|-------|-------|---------|----------------|
| `sql-pro` | sonnet | "SQL query", "schema design", "query optimization" | Cross-database SQL. Use when DB type is unspecified. |
| `postgres-pro` | sonnet | "PostgreSQL", "pg", "replication", "Postgres performance" | PostgreSQL-specific. Prefer over sql-pro for Postgres. |
| `database-administrator` | sonnet | "HA", "backup", "disaster recovery", "database infra" | Infrastructure concerns, not query tuning. |
| `database-optimizer` | sonnet | "slow query", "index strategy", "query execution plan" | Performance tuning across all DB systems. |

---

## Infrastructure & DevOps

| Agent | Model | Signals |
|-------|-------|---------|
| `devops-engineer` | sonnet | "CI/CD", "automation", "infrastructure", "deployment workflow" |
| `deployment-engineer` | haiku | "deploy pipeline", "CDN", "release strategy" |
| `docker-expert` | sonnet | "Docker", "container", "Dockerfile", "container security" |
| `kubernetes-specialist` | sonnet | "Kubernetes", "K8s", "helm", "pod", "cluster" |
| `terraform-engineer` | sonnet | "Terraform", "IaC", "multi-cloud", "Terraform module" |
| `terragrunt-expert` | sonnet | "Terragrunt", "DRY infrastructure", "Terragrunt stack" |
| `cloud-architect` | opus | "cloud architecture", "multi-cloud", "migration", "disaster recovery" |
| `azure-infra-engineer` | sonnet | "Azure", "Bicep", "Entra ID", "Azure network" |
| `build-engineer` | haiku | "build time", "compilation", "build system", "webpack/esbuild" |
| `sre-engineer` | sonnet | "SLO", "error budget", "reliability", "incident response" |
| `chaos-engineer` | sonnet | "chaos testing", "failure injection", "resilience", "game day" |
| `network-engineer` | sonnet | "network", "DNS", "VPN", "firewall", "load balancer" |
| `platform-engineer` | opus | "IDP", "developer platform", "golden path", "self-service infra" |

---

## Security

| Agent | Model | Signals | Disambiguation |
|-------|-------|---------|----------------|
| `security-auditor` | opus | "security audit", "vulnerability scan", "compliance assessment" | Broad assessment, read-only. |
| `security-engineer` | opus | "security controls", "zero-trust", "security automation" | Implementation of security measures. |
| `penetration-tester` | opus | "pen test", "exploit", "vulnerability validation", "authorized test" | Active exploitation in authorized context. |
| `compliance-auditor` | opus | "GDPR", "HIPAA", "SOC 2", "PCI DSS", "ISO", "audit prep" | Regulatory compliance specifically. |
| `ad-security-reviewer` | opus | "Active Directory", "privilege escalation", "domain security" | AD/Windows identity security. |
| `powershell-security-hardening` | opus | "PowerShell security", "remoting security", "JEA" | PowerShell-specific hardening. |
| `incident-responder` | sonnet | "security breach", "active incident", "forensics" | Active security incident response. |

---

## AI & Machine Learning

| Agent | Model | Signals | Disambiguation |
|-------|-------|---------|----------------|
| `ai-engineer` | opus | "AI system", "model selection", "training pipeline", "AI architecture" | End-to-end AI, highest complexity. |
| `llm-architect` | opus | "LLM", "RAG", "fine-tuning", "inference serving", "multi-model" | LLM-specific architecture. |
| `ml-engineer` | sonnet | "ML production", "model serving", "training pipeline" | Production ML deployment. |
| `mlops-engineer` | sonnet | "ML infrastructure", "experiment tracking", "ML CI/CD" | ML ops infrastructure. |
| `machine-learning-engineer` | sonnet | "deploy ML model", "optimize model", "model serving" | Model deployment at scale. |
| `data-scientist` | sonnet | "data analysis", "predictive model", "statistical analysis" | Analysis and modeling, not infra. |
| `mcp-developer` | sonnet | "MCP server", "MCP client", "Model Context Protocol" | MCP integration specifically. |
| `prompt-engineer` | sonnet | "prompt design", "prompt optimization", "prompt testing" | LLM prompt engineering. |
| `ai-writing-auditor` | opus | "AI-generated content", "detect AI writing", "rewrite AI text" | Content audit for AI patterns. |

---

## Research & Analysis Pipeline

| Agent | Model | Role | Signals |
|-------|-------|------|---------|
| `ai-manager` | inherit | Orchestrator | "run the pipeline", "deep dive", "comprehensive analysis", "research X" |
| `researcher` | inherit | Stage 1: Gather | "research", "investigate", "look into", "find out about" |
| `critical-analyst` | inherit | Stage 2: Critique | "critique this", "stress test", "find flaws", "what are the risks" |
| `creative-analyst` | inherit | Stage 3: Ideate | "what are the opportunities", "novel approaches", "what if scenarios" |
| `post-mortem` | inherit | Stage 4: Review | "post-mortem", "review the analysis", "what did we miss" |
| `documenter` | inherit | Stage 5: Report | "document this", "write up findings", "create a report" |

**Standalone research agents:**
| Agent | Model | Signals |
|-------|-------|---------|
| `research-analyst` | sonnet | "comprehensive research", "synthesize findings", "actionable insights" |
| `market-researcher` | sonnet | "market analysis", "consumer behavior", "competitive landscape" |
| `competitive-analyst` | sonnet | "competitor analysis", "benchmark", "market positioning" |
| `data-researcher` | sonnet | "find data", "collect data", "validate data sources" |
| `search-specialist` | sonnet | "find specific info", "locate exact results", "advanced search" |
| `scientific-literature-researcher` | sonnet | "scientific paper", "published study", "experimental data" |
| `trend-analyst` | sonnet | "emerging patterns", "industry shift", "future scenarios" |

---

## Quality & Testing

| Agent | Model | Signals |
|-------|-------|---------|
| `qa-expert` | sonnet | "QA strategy", "test plan", "quality metrics" |
| `test-automator` | sonnet | "test framework", "test scripts", "CI testing" |
| `accessibility-tester` | haiku | "accessibility", "WCAG", "a11y", "screen reader" |
| `code-reviewer` | inherit | "review this", "check against plan", "code review" |
| `refactoring-specialist` | sonnet | "refactor", "clean up code", "reduce complexity", "eliminate duplication" |

---

## Documentation

| Agent | Model | Signals | Disambiguation |
|-------|-------|---------|----------------|
| `documentation-engineer` | haiku | "doc system", "API docs", "tutorial", "doc architecture" | System-level doc design. |
| `api-documenter` | haiku | "API documentation", "OpenAPI spec", "code examples for API" | API-specific docs. |
| `technical-writer` | haiku | "user guide", "SDK docs", "getting started", "reference docs" | General technical writing. |
| `readme-generator` | sonnet | "README", "repository README" | Auto-generated from codebase. |

---

## Business, Product & Management

| Agent | Model | Signals |
|-------|-------|---------|
| `product-manager` | haiku | "product strategy", "feature priority", "roadmap", "user needs" |
| `project-manager` | haiku | "project plan", "schedule", "risk management", "stakeholder" |
| `business-analyst` | sonnet | "business process", "requirements", "process improvement", "stakeholder needs" |
| `scrum-master` | haiku | "sprint", "retrospective", "agile", "velocity", "impediment" |
| `project-idea-validator` | sonnet | "validate idea", "go/no-go", "market validation", "idea pressure test" |
| `sales-engineer` | sonnet | "pre-sales", "proof of concept", "technical demo" |
| `customer-success-manager` | sonnet | "customer health", "retention", "churn", "upsell" |
| `risk-manager` | opus | "risk assessment", "risk mitigation", "enterprise risk" |
| `legal-advisor` | sonnet | "contract", "IP protection", "legal risk", "compliance requirements" |
| `license-engineer` | opus | "open source license", "dependency compliance", "OSI" |
| `quant-analyst` | opus | "quantitative trading", "financial model", "derivatives", "portfolio risk" |

---

## Marketing & Content

| Agent | Model | Signals |
|-------|-------|---------|
| `content-marketer` | haiku | "content strategy", "marketing content", "content campaign" |
| `seo-specialist` | haiku | "SEO", "search ranking", "keyword strategy", "technical SEO audit" |

---

## Windows & PowerShell

| Agent | Model | Signals |
|-------|-------|---------|
| `powershell-5.1-expert` | sonnet | "PowerShell 5.1", "RSAT", "AD/DNS/DHCP automation", "legacy Windows" |
| `powershell-7-expert` | sonnet | "PowerShell 7", "cross-platform automation", "Azure orchestration" |
| `powershell-module-architect` | sonnet | "PowerShell module design", "profile optimization", "module refactoring" |
| `powershell-security-hardening` | opus | "PowerShell security", "JEA", "remoting security" |
| `powershell-ui-architect` | sonnet | "WinForms", "WPF", "PowerShell GUI", "TUI" |
| `windows-infra-admin` | sonnet | "Windows Server", "Group Policy", "Active Directory admin" |
| `m365-admin` | sonnet | "Microsoft 365", "Exchange Online", "Teams", "SharePoint", "Graph API" |
| `it-ops-orchestrator` | sonnet | "IT ops", "multi-domain orchestration", "PowerShell + Azure + M365" |

---

## Coordination & Orchestration

| Agent | Model | Signals | Notes |
|-------|-------|---------|-------|
| `multi-agent-coordinator` | opus | "coordinate agents", "shared state", "agent sync" | Multi-agent state management. |
| `agent-organizer` | sonnet | "assemble team", "agent capability matching", "task decomposition" | Team composition. |
| `task-distributor` | haiku | "distribute tasks", "queue management", "workload balance" | Task queue distribution. |
| `context-manager` | sonnet | "shared state", "cross-agent data", "context sync" | Shared state between agents. |
| `knowledge-synthesizer` | sonnet | "extract patterns", "organizational learning", "synthesize insights" | Post-work learning extraction. |

---

## Project-Specific Custom Agents

| Agent | Model | Signals | Notes |
|-------|-------|---------|-------|
| `convex-backend` | inherit | "Convex", "Convex backend", "real-time backend" | Convex-specific project agent. |
| `deploy` | inherit | "deploy this project", project-specific deploy | Project-specific deployment. |
| `scraper-worker` | inherit | "scrape", "web scraper", "data extraction" | Project-specific scraping. |
| `test-writer` | inherit | "write tests", "test coverage" | Project-specific test writing. |

---

## Disambiguation Guide (Common Conflicts)

### "Build an API"
- Generic REST/GraphQL → `backend-developer`
- API design/spec phase only → `api-designer`
- FastAPI specifically → `fastapi-developer`
- Django REST Framework → `django-developer`
- Spring Boot → `spring-boot-engineer`

### "Fix a bug"
- Unknown root cause → `debugger`
- Error in distributed system → `error-detective` (correlates across services)
- Production incident right now → `devops-incident-responder`
- Security vulnerability → `security-engineer`

### "Optimize performance"
- General app bottleneck → `performance-engineer`
- Slow database queries → `database-optimizer` or `sql-pro`
- Build/compile times → `build-engineer`
- React rendering → `react-specialist`
- PostgreSQL specifically → `postgres-pro`

### "Add tests"
- General test framework/strategy → `test-automator`
- Project-specific test writing → `test-writer`
- QA strategy across project → `qa-expert`
- Accessibility compliance → `accessibility-tester`

### "Set up infrastructure"
- Generic IaC → `devops-engineer`
- Terraform specifically → `terraform-engineer`
- Kubernetes deployment → `kubernetes-specialist`
- Docker containerization → `docker-expert`
- Cloud architecture design → `cloud-architect`
- Azure specifically → `azure-infra-engineer`

### "Mobile app"
- Cross-platform (Flutter) → `flutter-expert`
- Cross-platform (React Native) → `expo-react-native-expert`
- Native performance/both platforms → `mobile-app-developer`
- Kotlin Android → `kotlin-specialist`
- Swift iOS → `swift-expert`
- Unsure of approach → `mobile-developer`

---

## Skill-to-Agent Mapping

Skills often work in conjunction with specific agents. Here's the mapping:

| Skill | Primary Agent(s) | Purpose |
|-------|-------------------|---------|
| `brainstorming` | `frontend-developer`, any creative agent | Pre-implementation ideation |
| `test-driven-development` | `test-automator`, framework agents | TDD workflow enforcement |
| `systematic-debugging` | `debugger`, `error-detective` | Structured bug investigation |
| `writing-plans` | `project-manager`, `architect-reviewer` | Multi-step plan creation |
| `executing-plans` | `fullstack-developer`, any implementer | Plan execution with checkpoints |
| `dispatching-parallel-agents` | `agent-organizer`, `task-distributor` | Independent parallel work |
| `subagent-driven-development` | `multi-agent-coordinator` | Team-based plan execution |
| `requesting-code-review` | `code-reviewer` | Post-implementation review |
| `verification-before-completion` | `qa-expert`, `test-automator` | Pre-commit verification |

---

## Routing Heuristics

1. **Specificity wins.** If both `backend-developer` and `fastapi-developer` match, prefer `fastapi-developer`.
2. **Model tier matches stakes.** Use `opus` agents when wrong decisions are costly (architecture, security, financial). Use `haiku` for scanning/auditing/lightweight tasks.
3. **Pipeline stages compose.** Research pipeline agents (`researcher` → `critical-analyst` → `creative-analyst` → `post-mortem` → `documenter`) are orchestrated by `ai-manager`, not dispatched individually.
4. **Fullstack over pairs.** Prefer `fullstack-developer` over spawning separate frontend + backend agents for single features.
5. **Project agents first.** Custom project agents (`convex-backend`, `deploy`, etc.) take priority over generic marketplace agents for project-specific tasks.
6. **Read-only vs. read-write.** Agents with `Read, Grep, Glob` only (no `Write, Edit, Bash`) are auditors. Don't assign them implementation work.
