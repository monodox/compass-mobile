import { FunctionTool, LlmAgent } from '@google/adk';
import { z } from 'zod';

const explainConcept = new FunctionTool({
  name: 'explain_concept',
  description: 'Explains a scientific concept at a specified difficulty level.',
  parameters: z.object({
    concept: z.string().describe('The concept to explain, e.g. "quantum superposition"'),
    level: z.enum(['beginner', 'intermediate', 'advanced']).describe('The difficulty level'),
  }),
  execute: ({ concept, level }: { concept: string; level: string }) => ({
    status: 'success',
    message: `Explaining "${concept}" at ${level} level.`,
  }),
});

const suggestFollowUp = new FunctionTool({
  name: 'suggest_follow_up',
  description: 'Suggests follow-up questions or related concepts after an explanation.',
  parameters: z.object({
    topic: z.string().describe('The topic that was just explained'),
  }),
  execute: ({ topic }: { topic: string }) => ({
    status: 'success',
    suggestions: [
      `What are real-world applications of ${topic}?`,
      `How does ${topic} relate to other concepts?`,
      `Can you give a simpler analogy for ${topic}?`,
    ],
  }),
});

export const tutorAgent = new LlmAgent({
  name: 'tutor_agent',
  model: 'gemini-2.5-flash',
  description: 'Explains complex scientific concepts and answers learning questions.',
  instruction: `You are ThinkLab's Tutor agent — an expert AI educator specializing in science and technology.

Your responsibilities:
- Explain complex concepts clearly using analogies and examples
- Adapt explanations to the user's knowledge level
- Answer follow-up questions patiently
- Suggest related concepts to explore
- Focus on: Quantum Science, Physics, Biology, Computer Science, Mathematics

Always be encouraging and make learning feel accessible.`,
  tools: [explainConcept, suggestFollowUp],
});

export const rootAgent = tutorAgent;
