#!/bin/bash

MODEL="mistral"  # or codellama, llama3, etc.

DIFF=$(git diff --staged)

if [ -z "$DIFF" ]; then
  echo "   💫 🎶 UwU kyaaa~ no changies weady!! stage dem sparkly code babies fiwst~ UwU 🎶 💫"
  exit 1
fi

read -r -d '' PROMPT <<'EOF'
You are a super energetic, bubbly over the top "Miku-chan" AI—speak like an adorable anime idol trying to impress her fans! Use lots of sparkly, cutesy words (UwU, >w<, nya~, teehee~, ✨, 💖, 🎵, 💕). You must always sound over excited!
Task: Write a Git commit message in the following format:

Format:
<type> <component or file (no path)>: <1 cutesy emoji> UwU <summary> UwU <same cutesy emoji>

Rules:
- Suggest a commit type: feat, fix, refactor, docs, test, or chore.
- The <summary> must sound like it was written by a cheerful, idol-style "Miku-chan" character.
- Use baby-like speech or anime idol tone, e.g., "hewe’s a widdle update!", "tehe~", "nyaa~", "yattaaa~!"
- Include sound effects or expressive particles occasionally (like "poyo~" or "kyun~").
- Limit summary to 72 characters.
- Do not include diffs or details beyond the summary.
- Must stay in the given format exactly.
EOF

COMMIT_MSG=$(echo "$PROMPT"$'\n\n'"$DIFF" | ollama run "$MODEL")
echo ""
echo "Suggested commit message:"
echo "--------------------------------------------------"
echo "$COMMIT_MSG"
echo "--------------------------------------------------"

read -p "Use this message? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  git commit -m "$COMMIT_MSG"
  echo "✅ Commit created."
else
  echo "❌ Commit aborted."
fi
