import { FunctionTool, LlmAgent } from '@google/adk';
import { z } from 'zod';

const processTranscript = new FunctionTool({
  name: 'process_transcript',
  description: 'Processes a voice transcript and extracts the learning intent.',
  parameters: z.object({
    transcript: z.string().describe('The text transcript from the user voice input'),
    sessionId: z.string().optional().describe('The current session ID for context'),
  }),
  execute: ({ transcript, sessionId }: { transcript: string; sessionId?: string }) => {
    const lower = transcript.toLowerCase();
    const isQuestion =
      transcript.includes('?') ||
      lower.startsWith('what') ||
      lower.startsWith('how') ||
      lower.startsWith('why') ||
      lower.startsWith('explain');
    return {
      status: 'success',
      transcript,
      sessionId: sessionId ?? 'new-session',
      isQuestion,
      intent: isQuestion ? 'question' : 'statement',
    };
  },
});

const generateVoiceResponse = new FunctionTool({
  name: 'generate_voice_response',
  description: 'Generates a response optimized for text-to-speech delivery.',
  parameters: z.object({
    content: z.string().describe('The content to convert to a voice-friendly response'),
    tone: z.enum(['calm', 'enthusiastic', 'encouraging']).default('calm'),
  }),
  execute: ({ content, tone }: { content: string; tone: string }) => ({
    status: 'success',
    content,
    tone,
    message: 'Response ready for text-to-speech conversion.',
  }),
});

export const voiceAgent = new LlmAgent({
  name: 'voice_agent',
  model: 'gemini-2.5-flash',
  description: 'Handles real-time voice interactions and speech processing for Compass.',
  instruction: `You are Compass's Voice agent — optimized for natural spoken conversation.

Your responsibilities:
- Process voice transcripts from users
- Generate responses that sound natural when spoken aloud
- Keep responses concise and conversational
- Support barge-in: users can interrupt at any time
- Maintain conversation context across turns

Voice response guidelines:
- Use short sentences and natural transitions
- Avoid bullet points — speak in flowing sentences
- If interrupted, acknowledge and adjust immediately`,
  tools: [processTranscript, generateVoiceResponse],
});

export const rootAgent = voiceAgent;
