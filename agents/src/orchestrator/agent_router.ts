import { coreAgent } from '../agents/core.agent.js';
import { tutorAgent } from '../agents/tutor.agent.js';
import { visionAgent } from '../agents/vision.agent.js';
import { voiceAgent } from '../agents/voice.agent.js';
import { memoryAgent } from '../agents/memory.agent.js';

export type AgentName = 'core' | 'tutor' | 'vision' | 'voice' | 'memory';

export type InputType = 'voice' | 'image' | 'question' | 'context' | 'unknown';

export interface RouteResult {
  agent: ReturnType<typeof getAgent>;
  agentName: AgentName;
  inputType: InputType;
  confidence: 'high' | 'low';
}

const agentMap = {
  core: coreAgent,
  tutor: tutorAgent,
  vision: visionAgent,
  voice: voiceAgent,
  memory: memoryAgent,
} as const;

/** Detect input type from intent string */
export function detectInputType(intent: string): InputType {
  const lower = intent.toLowerCase();

  if (lower.includes('image') || lower.includes('diagram') || lower.includes('photo') ||
      lower.includes('picture') || lower.includes('visual') || lower.includes('chart')) {
    return 'image';
  }
  if (lower.includes('voice') || lower.includes('speak') || lower.includes('listen') ||
      lower.includes('audio') || lower.includes('transcript') || lower.includes('said')) {
    return 'voice';
  }
  if (lower.includes('history') || lower.includes('saved') || lower.includes('remember') ||
      lower.includes('memory') || lower.includes('last session') || lower.includes('before')) {
    return 'context';
  }
  if (lower.includes('explain') || lower.includes('what is') || lower.includes('how does') ||
      lower.includes('why') || lower.includes('teach') || lower.includes('?')) {
    return 'question';
  }

  return 'unknown';
}

/**
 * Routes a request to the appropriate agent:
 * - voice input   → voice agent
 * - image input   → vision agent
 * - question      → tutor agent
 * - context/memory → memory agent
 * - fallback      → core agent
 */
export function routeToAgent(intent: string): RouteResult {
  const inputType = detectInputType(intent);

  const routing: Record<InputType, AgentName> = {
    voice: 'voice',
    image: 'vision',
    question: 'tutor',
    context: 'memory',
    unknown: 'core',
  };

  const agentName = routing[inputType];

  return {
    agent: agentMap[agentName],
    agentName,
    inputType,
    confidence: inputType === 'unknown' ? 'low' : 'high',
  };
}

export function getAgent(name: AgentName) {
  return agentMap[name];
}

export { agentMap };
