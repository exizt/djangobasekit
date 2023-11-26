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
    python manage.py runserver 0.0.0.0:80
else
    echo "[entrypoint.sh] .env not found"
    exit 1
fi

