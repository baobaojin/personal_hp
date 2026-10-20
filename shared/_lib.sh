# 彩色日志
log_info() {
  echo -e "\033[32m[INFO]\033[0m $*"
}

log_warn() {
  echo -e "\033[33m[WARN]\033[0m $*"
}

log_error() {
  echo -e "\033[31m[ERROR]\033[0m $*"
}

log_step() {
  echo -e "\033[36m[STEP]\033[0m $*"
}

# 命令检查
check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# 获取仓库根目录
get_repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

# 执行步骤数组，统计成功/失败
run_steps() {
  local steps=("$@")
  local success=0
  local failed=0
  local total=${#steps[@]}

  for step_cmd in "${steps[@]}"; do
    local step_name
    step_name=$(basename "$step_cmd")
    log_step "[$((success + failed + 1))/$total] $step_name ..."
    if bash "$step_cmd"; then
      success=$((success + 1))
    else
      failed=$((failed + 1))
      log_error "步骤失败：$step_name"
    fi
  done

  echo ""
  if [ "$failed" -eq 0 ]; then
    log_info "完成（$success/$total 成功）"
  else
    log_warn "完成（$success 成功，$failed 失败）"
  fi
}
