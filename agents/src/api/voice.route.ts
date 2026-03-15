import { Router, Request, Response } from 'express';
import { voiceAgent } from '../agents/voice.agent.js';
import { GeminiService } from '../services/gemini.service.js';
import { csrfProtection } from '../middleware/csrf.middleware.js';

const router = Router();

/**
 * POST /api/voice/transcript
 * Body: { transcript: string, sessionId?: string }
 */
router.post('/transcript', csrfProtection, async (req: Request, res: Response) => {
  const { transcript, sessionId } = req.body as {
    transcript: string;
    sessionId?: string;
  };

  if (!transcript) {
    res.status(400).json({ error: 'transcript is required' });
    return;
  }

  const lower = transcript.toLowerCase();
  const isQuestion =
    typeof transcript === 'string' && (
    transcript.includes('?') ||
    lower.startsWith('what') ||
    lower.startsWith('how') ||
    lower.startsWith('why') ||
    lower.startsWith('explain'));

  try {
    // TODO: invoke voiceAgent.run() when ADK runner is configured
    res.json({
      agent: voiceAgent.name,
      transcript,
      sessionId: sessionId ?? 'new-session',
      isQuestion,
      intent: isQuestion ? 'question' : 'statement',
    });
  } catch (err) {
    res.status(500).json({ error: 'Voice agent error', details: String(err) });
  }
});

/**
 * GET /api/voice/live-config
 * Returns the Gemini Live API WebSocket URL and setup payload for the client
 */
router.get('/live-config', (_req: Request, res: Response) => {
  const setup = GeminiService.buildSetupPayload(
    "You are Compass's Voice agent. Explain concepts conversationally and naturally.",
  );
  res.json({
    wsUrl: GeminiService.liveApiUrl(),
    setup,
  });
});

export default router;
