import { Router, Request, Response } from 'express';
import { tutorAgent } from '../agents/tutor.agent.js';

const router = Router();

/**
 * POST /api/tutor/explain
 * Body: { concept: string, level?: 'beginner' | 'intermediate' | 'advanced', userId?: string }
 */
router.post('/explain', async (req: Request, res: Response) => {
  const { concept, level = 'intermediate', userId } = req.body as {
    concept: string;
    level?: string;
    userId?: string;
  };

  if (!concept) {
    res.status(400).json({ error: 'concept is required' });
    return;
  }

  try {
    // TODO: invoke tutorAgent.run() with session context when ADK runner is configured
    res.json({
      agent: tutorAgent.name,
      concept,
      level,
      userId: userId ?? 'anonymous',
      message: `Tutor agent ready to explain "${concept}" at ${level} level.`,
    });
  } catch (err) {
    res.status(500).json({ error: 'Tutor agent error', details: String(err) });
  }
});

/**
 * POST /api/tutor/followup
 * Body: { topic: string }
 */
router.post('/followup', async (req: Request, res: Response) => {
  const { topic } = req.body as { topic: string };

  if (!topic) {
    res.status(400).json({ error: 'topic is required' });
    return;
  }

  res.json({
    agent: tutorAgent.name,
    topic,
    suggestions: [
      `What are real-world applications of ${topic}?`,
      `How does ${topic} relate to other concepts?`,
      `Can you give a simpler analogy for ${topic}?`,
    ],
  });
});

export default router;
