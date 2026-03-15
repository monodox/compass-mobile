import { FunctionTool, LlmAgent } from '@google/adk';
import { z } from 'zod';

const saveConcept = new FunctionTool({
  name: 'save_concept',
  description: 'Saves a learned concept to the user learning history.',
  parameters: z.object({
    userId: z.string(),
    concept: z.string(),
    subject: z.string(),
    summary: z.string(),
  }),
  execute: ({ userId, concept, subject, summary }: { userId: string; concept: string; subject: string; summary: string }) => ({
    status: 'success',
    saved: { userId, concept, subject, summary, savedAt: new Date().toISOString() },
    message: `Concept "${concept}" saved for user ${userId}.`,
  }),
});

const retrieveHistory = new FunctionTool({
  name: 'retrieve_history',
  description: 'Retrieves the learning history and saved concepts for a user.',
  parameters: z.object({
    userId: z.string(),
    limit: z.number().optional().default(10),
  }),
  execute: ({ userId, limit }: { userId: string; limit?: number }) => ({
    status: 'success',
    userId,
    limit: limit ?? 10,
    history: [],
    message: `Retrieved up to ${limit ?? 10} history records for user ${userId}.`,
  }),
});

const getPersonalizationContext = new FunctionTool({
  name: 'get_personalization_context',
  description: 'Builds a personalization context from user history to improve AI responses.',
  parameters: z.object({ userId: z.string() }),
  execute: ({ userId }: { userId: string }) => ({
    status: 'success',
    userId,
    context: {
      topicsExplored: [],
      preferredLevel: 'intermediate',
      sessionCount: 0,
      lastSession: null,
    },
  }),
});

export const memoryAgent = new LlmAgent({
  name: 'memory_agent',
  model: 'gemini-2.5-flash',
  description: 'Stores and retrieves user learning history to personalize the ThinkLab experience.',
  instruction: `You are ThinkLab's Memory agent — responsible for learning persistence and personalization.

Your responsibilities:
- Save concepts and summaries after each learning session
- Retrieve past sessions to provide context for new conversations
- Build personalization profiles based on learning history
- Track progress across subjects

When a session ends:
1. Extract key concepts discussed
2. Save them with subject tags and summaries
3. Update the user's progress tracker
4. Suggest what to review or explore next`,
  tools: [saveConcept, retrieveHistory, getPersonalizationContext],
});

export const rootAgent = memoryAgent;
