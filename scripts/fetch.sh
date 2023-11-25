#!/bin/bash
#
# ##########################################
# 프로덕션 환경에서 git pull 및 패치 받기 스크립트.
#
# Description
#   - 프로덕션/Dev 환경에서 Git 내려받기 위한 용도.
#
#
# bash handling (bash가 아니면 bash로 실행)
if [ -z "$BASH_VERSION" ]; then exec bash "$0" "$@"; exit; fi
# PATHs
SCRIPTS_PATH=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") # 스크립트의 경로
MODULE_PATH="${SCRIPTS_PATH}/.." # 현재 서브 모듈의 경로
PROJECT_PATH="${MODULE_PATH}/.." # 상위 프로젝트의 경로

# git 변경사항 있는지 체크하는 함수
function git_update_check() {
    # git 현재 브랜치 얻어오기
    # https://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
    # https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
    # git branch --no-color | grep -E '^\*' | awk '{print $2}' || echo "master"
    # git symbolic-ref --short -q HEAD
    current_branch=$(git branch --show-current || echo "master")

    # git 변경사항 체크
    git fetch origin $current_branch
    git_behind_count=$(git rev-list HEAD..origin/$current_branch --count)
    if [[ "${git_behind_count}" == "0" ]]; then
        echo "false"
        return
    else
        echo "true"
        return
    fi
}

# ### 프로젝트 git 갱신
cd $PROJECT_PATH

# [프로젝트의 git] 깃에서 퍼미션은 추적하지 않도록 설정
git config core.fileMode false

# git 갱신 사항이 있는지 확인하고, 없으면 스크립트 종료.
# if ! git_update_check; then exit 1; fi
[ $(git_update_check) != "true" ] && exit 1

# git 갱신 (서브모듈 포함)
git pull --recurse-submodules


# ### 서브 모듈 git 관련
# 모듈의 경로로 이동.
cd $MODULE_PATH

# [모듈 - git] 태그를 삭제하고 다시 태그 받아옴
git tag -d $(git tag) && git fetch --all

# [모듈 - git] 체크아웃 없이 main 브랜치를 원격에 맞춰서 갱신
git fetch origin main:main

# 프로젝트의 경로로 이동
cd $PROJECT_PATH
