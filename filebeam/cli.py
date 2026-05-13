import argparse
import sys
from pathlib import Path

from .providers import PROVIDERS, DEFAULT_PROVIDER
from . import config as cfg


# ---------- upload ----------

def cmd_upload(args: argparse.Namespace) -> None:
    if not args.file.exists():
        print(f"error: file not found: {args.file}", file=sys.stderr)
        sys.exit(1)
    if not args.file.is_file():
        print(f"error: not a file: {args.file}", file=sys.stderr)
        sys.exit(1)

    provider_cls = PROVIDERS[args.provider]
    kwargs = {}
    if args.token:
        kwargs["token"] = args.token

    try:
        provider = provider_cls(**kwargs)
        result = provider.upload(
            file_path=args.file,
            description=args.description,
            public=not args.private,
        )
    except (ValueError, RuntimeError) as e:
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)

    print(result.url)


# ---------- config ----------

def cmd_config_provider(args: argparse.Namespace) -> None:
    cfg.set_token(args.provider_name, args.token)
    print(f"Token saved for '{args.provider_name}'.")


def cmd_config_show(args: argparse.Namespace) -> None:
    data = cfg.load()
    providers = data.get("providers", {})
    if not providers:
        known = ", ".join(f"filebeam config {p} <token>" for p in PROVIDERS)
        print(f"No tokens configured. Example: {known}")
        return
    for provider, values in providers.items():
        token = values.get("token", "")
        masked = token[:4] + "*" * (len(token) - 4) if len(token) > 4 else "****"
        print(f"{provider}: {masked}")


# ---------- parser ----------

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="filebeam",
        description="Beam files up to a storage provider.",
    )
    sub = parser.add_subparsers(dest="command", metavar="command")
    sub.required = True

    # -- upload --
    up = sub.add_parser("upload", aliases=["up"], help="Upload a file")
    up.add_argument("file", type=Path, help="File to upload")
    up.add_argument(
        "--provider", "-p",
        choices=list(PROVIDERS),
        default=DEFAULT_PROVIDER,
        help=f"Storage provider (default: {DEFAULT_PROVIDER})",
    )
    up.add_argument("--description", "-d", default="", help="Description for the upload")
    up.add_argument("--private", action="store_true", help="Make the upload private/secret")
    up.add_argument("--token", "-t", default=None, help="Override stored token for this run")
    up.set_defaults(func=cmd_upload)

    # -- config --
    conf = sub.add_parser("config", help="Manage provider credentials")
    conf_sub = conf.add_subparsers(dest="config_command", metavar="config_command")
    conf_sub.required = True

    # one subcommand per registered provider: `filebeam config github-gist <token>`
    for provider_name in PROVIDERS:
        p = conf_sub.add_parser(provider_name, help=f"Set token for {provider_name}")
        p.add_argument("token", help=f"Auth token for {provider_name}")
        p.set_defaults(func=cmd_config_provider, provider_name=provider_name)

    show = conf_sub.add_parser("show", help="Show all stored tokens (masked)")
    show.set_defaults(func=cmd_config_show)

    return parser


def main():
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
