Описание/Пошаговая инструкция выполнения домашнего задания:
В материалах приложен файл бэкапа backup_des.xbstream.gz.des3 и дамп структуры базы world-db.sql
Бэкап выполнен с помощью команды:
sudo xtrabackup --backup --stream=xbstream
--target-dir=/tmp/backups/xtrabackup/stream
| gzip - | openssl des3 -salt -k "password" \

stream/backup_des.xbstream.gz.des3
Требуется восстановить таблицу world.city из бэкапа и выполнить оператор:
select count(*) from city where countrycode = 'RUS';
Результат оператора написать в чат с преподавателем.

Скачиваем файл world_db-195395-3b193e.sql
Создаем БД world
```
mysql -hlocalhost -P3306 -uroot -p -e "create database world; show databases;"
```
восстанавливаем таблицу city
```
mysql -hlocalhost -P3306 -uroot -p world < world_db-195395-3b193e.sql
```
Проверяем есть ли файл с таблицей city
```
ls /var/lib/mysql/world
```
city.ibd  country.ibd  countrylanguage.ibd
Скачиваем файл backup_des.xbstream.gz-195395-7bc8ae.des3
Расшифровываем файл
```
openssl des3 -salt -k "password" -d -in backup_des.xbstream.gz-195395-7bc8ae.des3 -out /tmp/backups/xtrabackup/stream/backup_des.xbstream.gz
```
Распаковываем архив
```
gzip -d /tmp/backups/xtrabackup/stream/backup_des.xbstream.gz
```
Переходим в папку stream и запускаем команду xbstream
```
cd stream
xbstream -x < backup_des.xbstream
```
Запускаем команду prepare
```
sudo xtrabackup --user=root --password=password --prepare --export --target-dir=/tmp/backups/xtrabackup/stream
```
Отключаем tablespace
```
mysql -uroot -p world -e "alter table city discard tablespace;"
```
Копируем файл для таблицы city
```
sudo cp world/city.ibd /var/lib/mysql/world
```
Устанавливаем владельца
```
sudo chown -R mysql.mysql /var/lib/mysql/world/city.ibd
```
Возвращаем tablespace
```
mysql -uroot world -e "alter table city import tablespace;"
```
Запрашиваем данные из таблицы city
```
root@debian:/tmp/backups/xtrabackup/stream# mysql -uroot -p world -e "select count(*) from city where countrycode = 'RUS';"
```
+----------+
| count(*) |
+----------+
|      189 |
+----------+
