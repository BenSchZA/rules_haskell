load(
    "@io_tweag_rules_haskell//haskell:providers.bzl",
    "HaskellInfo",
    "HaskellLibraryInfo",
)
load("//haskell:private/set.bzl", "set")

def _get_libraries_as_runfiles_impl(ctx):
    """Extract all library files from a haskell_library target
    and put them in this target’s files"""
    cc_info = ctx.attr.library[CcInfo]
    return [DefaultInfo(
        # not necessarily complete
        files = depset(
            transitive = [
                depset([
                    f
                    for lib in cc_info.linking_context.libraries_to_link
                    for f in [lib.static_library, lib.dynamic_library]
                    if f
                ]),
            ],
        ),
    )]

get_libraries_as_runfiles = rule(
    _get_libraries_as_runfiles_impl,
    attrs = {
        "library": attr.label(
            mandatory = True,
            providers = [HaskellInfo, HaskellLibraryInfo],
        ),
    },
)
