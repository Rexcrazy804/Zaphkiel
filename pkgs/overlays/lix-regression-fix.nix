# left here in loving memory of wanting to kms
# if you feel the same, please go to https://988lifeline.org/
# https://lix.systems/blog/2025-06-27-lix-critical-bug/
# Yours Lovingly,
# Rexiel Scarlet - june 29, 2025
final: prev: {
  lixPackageSets = prev.lixPackageSets.extend (final': prev': {
    lix_2_93 = prev'.lix_2_93.overrideScope (new: old: {
      lix = old.lix.overrideAttrs (_new: old': {
        patches =
          (old'.patches or [])
          ++ [
            (final.fetchpatch2 {
              decode = "base64 -d";
              url = "https://gerrit.lix.systems/changes/lix~3501/revisions/9/patch?download";
              hash = "sha256-iRP4tE5Fd8POlAIOhT9JjebxE7ZZzXI6skYSxO3efhs=";
            })
            (final.fetchpatch2 {
              decode = "base64 -d";
              url = "https://gerrit.lix.systems/changes/lix~3510/revisions/7/patch?download";
              hash = "sha256-5Pg1pAW5UyPEX4zGd7ZeZ5ILMPH+erfHQxTG6FHuilc=";
              postFetch = ''
                substituteInPlace $out --replace-fail "false" "true"
              '';
            })
          ];
      });
    });
  });
}
