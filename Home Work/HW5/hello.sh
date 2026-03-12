#!/bin/bash

NAME=${1:-$USER}

CURRENT_DATE=$(date)

echo "Здравствуйте, $NAME. Скрипт запущен: $CURRENT_DATE. Количество переданных аргументов: $#."

if [ $? -eq 0 ]; then
  echo "Завершено успешно"
else
  echo "Завершено с ошибкой"
fi