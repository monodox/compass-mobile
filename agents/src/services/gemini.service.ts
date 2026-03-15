import 'dotenv/config';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY ?? '';
const LIVE_API_BASE = 'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent';
const REST_API_BASE = 'https://generativelanguage.googleapis.com/v1beta';

if (!GEMINI_API_KEY) {
  console.warn('[GeminiService] GEMINI_API_KEY is not set. Check your .env.local file.');
}

export const GeminiService = {
  apiKey: GEMINI_API_KEY,

  /** WebSocket URL for Gemini Live API */
  liveApiUrl(): string {
    return `${LIVE_API_BASE}?key=${GEMINI_API_KEY}`;
  },

  /** REST endpoint for a given model and method */
  restUrl(model: string, method: string): string {
    return `${REST_API_BASE}/models/${model}:${method}?key=${GEMINI_API_KEY}`;
  },

  /** Default setup payload for a Live API session */
  buildSetupPayload(systemInstruction: string, voiceName = 'Aoede') {
    return {
      setup: {
        model: 'models/gemini-2.0-flash-live-001',
        generation_config: {
          response_modalities: ['AUDIO', 'TEXT'],
          speech_config: {
            voice_config: {
              prebuilt_voice_config: { voice_name: voiceName },
            },
          },
        },
        system_instruction: {
          parts: [{ text: systemInstruction }],
        },
      },
    };
  },

  /** Wrap a text turn for the Live API */
  buildTextTurn(text: string) {
    return {
      client_content: {
        turns: [{ role: 'user', parts: [{ text }] }],
        turn_complete: true,
      },
    };
  },

  /** Wrap a PCM audio chunk for the Live API */
  buildAudioChunk(base64Data: string) {
    return {
      realtime_input: {
        media_chunks: [{ mime_type: 'audio/pcm', data: base64Data }],
      },
    };
  },
};
