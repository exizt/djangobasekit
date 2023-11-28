#!/bin/bash

# echo "wait db server"
# dockerize -wait tcp://data-api:5000 -timeout 20s

# migrate + create super user
# python manage.py migrate
# python manage.py createsuperuser --noinput

# create table
# python manage.py make_discussion_board

# create stock data
# python manage.py update_stock

cd /srv/app

# 개발 모드에서만 필요함.
# pip install django-debug-toolbar


if [ -f /srv/app/.env ]; then
    # .env 파일이 설정되어있을 때에만 실행. 아닌 경우에는 의미가 없는 듯.
    echo "run django server"
    # python manage.py runserver 0.0.0.0:80
    # --noinput : 사용자에게 입력/질의를 요구하지 않음
    # --link : 심볼릭 링크로 생성 (참고: 디렉터리가 아닌, 파일 하나하나 심볼릭 링크로 생성함)
    # --clear : 작업 전 기존 파일을 지움.
    # python manage.py collectstatic --link --clear --noinput
    # --link 옵션을 사용하면, 파이썬 패키지의 리소스도 심볼릭 링크가 걸리는데. nginx에서 읽지를 못함...
    # python manage.py collectstatic  --clear --noinput
    # gunicorn config.wsgi:application --bind 0.0.0.0:8000
    gunicorn config.wsgi:application -c /srv/gunicorn.conf.py
else
    echo "[entrypoint.sh] .env file not found"
    exit 1
fi

