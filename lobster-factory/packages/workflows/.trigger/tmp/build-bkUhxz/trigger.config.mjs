import {
  defineConfig
} from "./chunk-C6SFAHUG.mjs";
import "./chunk-35EY4FVJ.mjs";
import "./chunk-PYEDTJUC.mjs";
import "./chunk-SZHP2B4O.mjs";
import "./chunk-XBEFRFRI.mjs";
import {
  init_esm
} from "./chunk-J4P35T43.mjs";

// trigger.config.ts
init_esm();
var trigger_config_default = defineConfig({
  project: "proj_rqykzzwujizcxdzgnedn",
  dirs: ["./src/trigger"],
  maxDuration: 300,
  retries: {
    enabledInDev: false,
    default: {
      maxAttempts: 3,
      minTimeoutInMs: 1e3,
      maxTimeoutInMs: 1e4,
      factor: 2,
      randomize: true
    }
  },
  build: {}
});
var resolveEnvVars = void 0;
export {
  trigger_config_default as default,
  resolveEnvVars
};
//# sourceMappingURL=trigger.config.mjs.map
