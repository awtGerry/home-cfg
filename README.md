# NixOS Configuration
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Configuracion de mi sistema utilizando nix y [home-manager](https://github.com/nix-community/home-manager)

> [!NOTE]
> Esta configuracion esta hecha para poder aprender mejor Nix, no soy ningun experto y no quiero
> hacerme pasar por uno, cualquier sugerencia para arreglar o mejorar seran bienvenidas.

> [!Warning]
> Esta configuracion apesar de quererla hacer semi modular esta pensada para utilizarse
> en mis computadoras, con mi sistema y hardware especificos.
> Puede no ser compatible con otro hardware (puede que si). Ten en cuenta que
> intentar lanzar esta configuracion en otro sistema puede resultar en un sistema
> no arrancable o en perdida de datos. Realiza cambios si es necesario.

## Hosts
* `artemis`: Soporta nuevo software, actualmente mi sistema principal (Wayland + Hyprland).
* `lyra`: Maquina que utiliza X, para software mas sencillo solo para programar. (_on progress_)
* `freya`: Sistema para portatiles, enfocado en la simplicidad y vida de la bateria (X11 + DWM). (_on progress_)


## Inspiracion y recursos
- [NobbZ: nixos-config](https://github.com/NobbZ/nixos-config)
- [Kira Bruneau: nixos-config](https://gitlab.com/kira-bruneau/nixos-config)
- [Misterio77: nix-config](https://github.com/Misterio77/nix-config/tree/main)
- [Janik](https://discourse.nixos.org/u/Janik/summary)
