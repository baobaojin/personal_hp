#!/usr/bin/env python3
"""
gen-marketplace.py
扫描 plugins/ 目录下所有插件，读取各文件的 frontmatter，
生成 plugins/marketplace.json。

每次 git commit 前由 pre-commit hook 自动触发。
也可以手动运行：python3 scripts/gen-marketplace.py
"""

import json
import os
import re
import sys

PLUGINS_DIR = os.path.join(os.path.dirname(__file__), "..", "plugins")
OUTPUT = os.path.join(PLUGINS_DIR, "marketplace.json")


def parse_frontmatter(filepath):
    """解析 markdown 文件的 YAML frontmatter，返回 dict"""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()

    if not content.startswith("---"):
        return {}

    end = content.find("---", 3)
    if end == -1:
        return {}

    fm_text = content[3:end].strip()
    result = {}

    for line in fm_text.splitlines():
        if ":" not in line:
            continue
        key, _, value = line.partition(":")
        key = key.strip()
        value = value.strip()

        # 处理列表（逗号分隔的触发词）
        if key in ("triggers", "not_for", "paths"):
            # 去掉首尾方括号
            value = value.strip("[]")
            # 按顿号或逗号分割
            if "、" in value:
                items = [v.strip().strip('"').strip("'").rstrip("。.") for v in value.split("、")]
            else:
                items = [v.strip().strip('"').strip("'").rstrip("。.") for v in value.split(",")]
            result[key] = [i for i in items if i]
        else:
            result[key] = value

    return result


def scan_personal_kb(plugin_dir):
    """扫描 personal-kb 插件"""
    plugin_json_path = os.path.join(plugin_dir, "plugin.json")
    with open(plugin_json_path, encoding="utf-8") as f:
        meta = json.load(f)

    skills = []

    type_map = {
        "skills": "skill",
        "skills-extended": "skill-extended",
        "workflows": "workflow",
    }

    for folder, skill_type in type_map.items():
        folder_path = os.path.join(plugin_dir, folder)
        if not os.path.isdir(folder_path):
            continue
        for fname in sorted(os.listdir(folder_path)):
            if not fname.endswith(".md"):
                continue
            fpath = os.path.join(folder_path, fname)
            fm = parse_frontmatter(fpath)
            if not fm.get("name"):
                continue
            skills.append({
                "name": fm["name"],
                "type": skill_type,
                "file": f"{folder}/{fname}",
                "description": fm.get("description", ""),
                "triggers": fm.get("triggers", []),
                "not_for": fm.get("not_for", ""),
            })

    return {
        "name": meta["name"],
        "version": meta["version"],
        "description": meta["description"],
        "skills": skills,
    }


def scan_dev(plugin_dir):
    """扫描 dev 插件"""
    rules = []
    skills = []

    # 扫描 rules
    rules_dir = os.path.join(plugin_dir, "rules")
    if os.path.isdir(rules_dir):
        for category in sorted(os.listdir(rules_dir)):
            cat_path = os.path.join(rules_dir, category)
            if not os.path.isdir(cat_path):
                continue
            for fname in sorted(os.listdir(cat_path)):
                if not fname.endswith(".md"):
                    continue
                fpath = os.path.join(cat_path, fname)
                fm = parse_frontmatter(fpath)
                if not fm.get("name"):
                    continue
                rules.append({
                    "name": fm["name"],
                    "category": category,
                    "file": f"rules/{category}/{fname}",
                    "description": fm.get("description", ""),
                    "paths": fm.get("paths", []),
                })

    # 扫描 skills
    skills_dir = os.path.join(plugin_dir, "skills")
    if os.path.isdir(skills_dir):
        for fname in sorted(os.listdir(skills_dir)):
            if not fname.endswith(".md"):
                continue
            fpath = os.path.join(skills_dir, fname)
            fm = parse_frontmatter(fpath)
            if not fm.get("name"):
                continue
            skills.append({
                "name": fm["name"],
                "type": "skill",
                "file": f"skills/{fname}",
                "description": fm.get("description", ""),
                "triggers": fm.get("triggers", []),
                "not_for": fm.get("not_for", ""),
            })

    return {
        "name": "dev",
        "version": "1.0.0",
        "description": "程序开发规范插件，按语言/领域细粒度安装",
        "rules": rules,
        "skills": skills,
    }


def main():
    plugins = []

    for plugin_name in sorted(os.listdir(PLUGINS_DIR)):
        plugin_dir = os.path.join(PLUGINS_DIR, plugin_name)
        if not os.path.isdir(plugin_dir):
            continue

        if plugin_name == "personal-kb":
            plugins.append(scan_personal_kb(plugin_dir))
        elif plugin_name == "dev":
            plugins.append(scan_dev(plugin_dir))
        # 后续新增插件在这里加分支

    marketplace = {"plugins": plugins}

    with open(OUTPUT, "w", encoding="utf-8") as f:
        json.dump(marketplace, f, ensure_ascii=False, indent=2)

    print(f"✅ marketplace.json 已生成（{sum(len(p.get('skills', [])) + len(p.get('rules', [])) for p in plugins)} 个条目）")


if __name__ == "__main__":
    main()
