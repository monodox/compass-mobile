# ThinkLab Agents

ADK TypeScript multi-agent system powering ThinkLab.

## Structure

```
agents/
├── package.json
├── tsconfig.json
├── src/
│   ├── agents/
│   │   ├── core.agent.ts       # Orchestrator
│   │   ├── tutor.agent.ts      # Concept explanations
│   │   ├── vision.agent.ts     # Image/diagram analysis
│   │   ├── voice.agent.ts      # Speech interaction
│   │   └── memory.agent.ts     # Learning history
│   ├── orchestrator/
│   │   └── agent_router.ts     # Routes requests to the right agent
│   ├── services/
│   │   └── gemini.service.ts   # Gemini API helpers
│   ├── api/
│   │   ├── tutor.route.ts      # POST /api/tutor/explain
│   │   ├── vision.route.ts     # POST /api/vision/analyze
│   │   └── voice.route.ts      # POST /api/voice/transcript
│   └── index.ts                # Express server entry point
```

## Setup

```bash
cd agents
npm install
```

Set your API key in the root `.env.local`:
```
GEMINI_API_KEY=your_gemini_api_key_here
```

## Run

```bash
# Express API server
npm start

# ADK web UI for a specific agent
npm run tutor     # http://localhost:8000
npm run vision
npm run voice
npm run memory
npm run core
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/tutor/explain` | Explain a concept |
| POST | `/api/tutor/followup` | Get follow-up suggestions |
| POST | `/api/vision/analyze` | Analyze an image |
| POST | `/api/vision/explain` | Explain a diagram |
| POST | `/api/voice/transcript` | Process voice transcript |
| GET  | `/api/voice/live-config` | Get Gemini Live WebSocket config |
| POST | `/api/route` | Auto-route intent to best agent |
| GET  | `/health` | Health check |
