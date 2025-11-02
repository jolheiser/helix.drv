<p align="center">
    <picture>
      <img alt="helix and nix logo" src="https://user.fm/files/v2-d436e1fd71e3ec042af2d52a5b2affe9/helix.drv.png" width="250">
    </picture>
    <h3 align="center">helix.drv</h3>
</p>

My helix setup, runnable via:

```sh
nix run git+https://git.jolheiser.com/helix.drv
```

## Extra LSPs
To add color LSP support to any given language, extend the LSPs configured for that language and add `colors`.

To add grammar checking, extend with `grammar`.

See [this server's configuration](.helix/languages.toml) for examples.

## License

[MIT](LICENSE)
