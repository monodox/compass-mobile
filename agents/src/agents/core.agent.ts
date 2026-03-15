import { LlmAgent } from '@google/adk';
import { tutorAgent } from './tutor.agent.js';
import { visionAgent } from './vision.agent.js';
import { voiceAgent } from './voice.agent.js';
import { memoryAgent } from './memory.agent.js';

/**
 * Core Agent — Coordinator/Dispatcher Pattern
 *
 * Uses LLM-driven delegation (transfer_to_agent) to route requests
 * to the appropriate specialist sub-agent based on user intent.
 *
 * Sub-agents are registered with clear descriptions so the LLM
 * can make informed routing decisions.
 */
export const coreAgent = new LlmAgent({
  name: 'core_agent',
  model: 'gemini-2.5-flash',
  description: 'Main ThinkLab coordinator. Routes learning requests to specialist agents.',
  instruction: `You are the Core agent of ThinkLab, an AI learning platform.

Analyze the user's request and delegate to the right specialist:
- Voice input or speech transcripts → transfer to voice_agent
- Images, diagrams, or visual content → transfer to vision_agent
- Questions, explanations, or concept learning → transfer to tutor_agent
- Learning history, saved concepts, or personalization → transfer to memory_agent

Always transfer — do not answer directly unless no specialist applies.`,
  subAgents: [tutorAgent, visionAgent, voiceAgent, memoryAgent],
});

export const rootAgent = coreAgent;
