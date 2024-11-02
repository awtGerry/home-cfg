inputs: {
  "profiles" = import ./profiles inputs;

  "profiles/base" = import ./profiles/base inputs;
  "profiles/dev" = import ./profiles/dev inputs;
  "profiles/browser" = import ./profiles/browser inputs;

}
