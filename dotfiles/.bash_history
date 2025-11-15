venv-up
bin/refresh-workspace
bin/m generate-ts-schemas
wf py check
wf py check --fix
wf py format
pnpm nx link flyui-dataviz -- -c ../workspace/
pnpm nx link flyui -- -c ../workspace/
pnpm nx storybook flyui-dataviz -- -p 6005
pnpm nx storybook flyui -- -p 6006
pnpm nx check-types broker-portal
pnpm nx test broker-portal
pnpm nx storybook broker-portal -- -p 6007
VITE_BROKERS_ENABLE_MSW=true pnpm nx dev broker-portal
wf scripts dev start
WF_USE_AUTH0_SANDBOX=true wf scripts dev start
