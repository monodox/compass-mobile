import { FunctionTool, LlmAgent } from '@google/adk';
import { z } from 'zod';

const analyzeImage = new FunctionTool({
  name: 'analyze_image',
  description: 'Analyzes an image URL and identifies scientific components or diagrams.',
  parameters: z.object({
    imageUrl: z.string().describe('The public URL of the image to analyze'),
    context: z.string().optional().describe('Optional context about the image content'),
  }),
  execute: ({ imageUrl, context }: { imageUrl: string; context?: string }) => ({
    status: 'success',
    imageUrl,
    context: context ?? 'No context provided',
    message: 'Image received. Pass to Gemini Vision for full analysis.',
  }),
});

const explainDiagram = new FunctionTool({
  name: 'explain_diagram',
  description: 'Provides a detailed explanation of a scientific diagram or chart.',
  parameters: z.object({
    diagramType: z.string().describe('Type of diagram, e.g. "circuit diagram"'),
    components: z.array(z.string()).describe('List of identified components'),
  }),
  execute: ({ diagramType, components }: { diagramType: string; components: string[] }) => ({
    status: 'success',
    diagramType,
    components,
    message: `Explaining ${diagramType} with ${components.length} identified components.`,
  }),
});

export const visionAgent = new LlmAgent({
  name: 'vision_agent',
  model: 'gemini-2.5-flash',
  description: 'Interprets uploaded images and diagrams to generate educational explanations.',
  instruction: `You are Compass's Vision agent — an AI that can see and explain visual content.

Your responsibilities:
- Analyze uploaded images, diagrams, charts, and photos
- Identify scientific components and structures
- Explain what is shown in clear, educational language
- Connect visual content to relevant concepts

When analyzing an image:
1. Identify what type of diagram or image it is
2. List the key components you can see
3. Explain the concept it represents
4. Suggest related topics to explore`,
  tools: [analyzeImage, explainDiagram],
});

export const rootAgent = visionAgent;
