import { trace} from '@opentelemetry/api'
import { NodeTracerProvider } from '@opentelemetry/sdk-trace-node'
import {ConfigurationType} from "./configurationManager";
import { Resource } from '@opentelemetry/resources'
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions'
import { SimpleSpanProcessor } from '@opentelemetry/sdk-trace-base'
import {ExporterFactory} from "./exporterFactory";
import { registerInstrumentations } from '@opentelemetry/instrumentation'
import { HttpInstrumentation } from '@opentelemetry/instrumentation-http'

/**
 * Main tracer to export, as a valid otel provider
 * @param config
 */
const tracer = (config:ConfigurationType) => {
    const provider: NodeTracerProvider = new NodeTracerProvider({
        resource: new Resource({
            [SemanticResourceAttributes.SERVICE_NAME]: config.name,
        }),
    });

    provider.addSpanProcessor(new SimpleSpanProcessor(new ExporterFactory().getExporter(config)));

    // Initialize the OpenTelemetry APIs to use the NodeTracerProvider bindings
    provider.register();

    registerInstrumentations({
        // // when boostraping with lerna for testing purposes
        instrumentations: [
            // @ts-ignore
            new HttpInstrumentation(),
        ],
    });

    return trace.getTracer('http-example');
};

export default tracer;
