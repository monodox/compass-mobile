import { Router, Request, Response } from 'express';
import { visionAgent } from '../agents/vision.agent.js';
import { csrfProtection } from '../middleware/csrf.middleware.js';

const router = Router();

/**
 * POST /api/vision/analyze
 * Body: { imageUrl: string, context?: string, userId?: string }
 */
router.post('/analyze', csrfProtection, async (req: Request, res: Response) => {
  const { imageUrl, context, userId } = req.body as {
    imageUrl: string;
    context?: string;
    userId?: string;
  };

  if (!imageUrl) {
    res.status(400).json({ error: 'imageUrl is required' });
    return;
  }

  try {
    // TODO: invoke visionAgent.run() with image content when ADK runner is configured
    res.json({
      agent: visionAgent.name,
      imageUrl,
      context: context ?? 'No context provided',
      userId: userId ?? 'anonymous',
      message: 'Vision agent ready to analyze the image.',
    });
  } catch (err) {
    res.status(500).json({ error: 'Vision agent error', details: String(err) });
  }
});

/**
 * POST /api/vision/explain
 * Body: { diagramType: string, components: string[] }
 */
router.post('/explain', csrfProtection, async (req: Request, res: Response) => {
  const { diagramType, components = [] } = req.body as {
    diagramType: string;
    components?: string[];
  };

  if (!diagramType) {
    res.status(400).json({ error: 'diagramType is required' });
    return;
  }

  res.json({
    agent: visionAgent.name,
    diagramType,
    components,
    message: `Vision agent ready to explain ${diagramType} with ${components.length} components.`,
  });
});

export default router;
