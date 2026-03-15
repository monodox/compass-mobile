import 'dotenv/config';
import express from 'express';
import tutorRouter from './api/tutor.route.js';
import visionRouter from './api/vision.route.js';
import voiceRouter from './api/voice.route.js';
import { routeToAgent } from './orchestrator/agent_router.js';

const app = express();
app.use(express.json());

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/api/tutor', tutorRouter);
app.use('/api/vision', visionRouter);
app.use('/api/voice', voiceRouter);

// ── Orchestrator ──────────────────────────────────────────────────────────────
app.post('/api/route', (req, res) => {
  const { intent } = req.body as { intent: string };
  if (!intent) {
    res.status(400).json({ error: 'intent is required' });
    return;
  }
  const result = routeToAgent(intent);
  res.json({
    routed_to: result.agentName,
    input_type: result.inputType,
    confidence: result.confidence,
    intent,
  });
});

// ── Health ────────────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'thinklab-agents' });
});

const PORT = process.env.PORT ?? 3000;
app.listen(PORT, () => {
  console.log(`ThinkLab Agents running on http://localhost:${PORT}`);
});

export default app;
