#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <feature_name>"
  echo "Example: $0 attendance"
  exit 1
fi

feature_raw="$1"
feature_name="$(echo "$feature_raw" | tr '[:upper:]' '[:lower:]' | tr ' -' '_' | tr -cd 'a-z0-9_')"

if [[ -z "$feature_name" ]]; then
  echo "Invalid feature name: $feature_raw"
  exit 1
fi

base_dir="lib/features/$feature_name"

mkdir -p "$base_dir/data/datasources"
mkdir -p "$base_dir/data/models"
mkdir -p "$base_dir/data/repositories"
mkdir -p "$base_dir/domain/entities"
mkdir -p "$base_dir/domain/repositories"
mkdir -p "$base_dir/domain/usecases"
mkdir -p "$base_dir/presentation/bloc"
mkdir -p "$base_dir/presentation/pages"
mkdir -p "$base_dir/presentation/widgets"

class_name="$(echo "$feature_name" | awk -F_ '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS='')"

cat > "$base_dir/presentation/pages/${feature_name}_page.dart" <<EOF
import 'package:flutter/material.dart';

class ${class_name}Page extends StatelessWidget {
  const ${class_name}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${class_name} Page'),
      ),
    );
  }
}
EOF

echo "Feature scaffold created at: $base_dir"
