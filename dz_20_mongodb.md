Выполним установку MongoDB 4.2.2 через Docker (Debian 11)
```
dbuserv@debian:~/code$ sudo docker pull mongo:4.2.2
```
```
dbuserv@debian:~/code$ sudo mkdir -p /mongodata
```
```
dbuserv@debian:~/code$ sudo docker run -it -v mongodata:/data/db --name mongodb -d mongo:4.2.2
```
```
dbuserv@debian:~/code$ sudo docker ps
```
![image](https://user-images.githubusercontent.com/62503531/200111633-706876ed-6197-4129-8f69-d052d8b12b39.png)
Подключимся к MongoDB 
![image](https://user-images.githubusercontent.com/62503531/200111773-6d52a9af-8675-49cc-a42c-c7e3d59e46f8.png)

Создадим базу mydb
```
use mydb
```
Создадим коллекцию mycol
```
db.createCollection("mycol")
```
```
> show dbs
```
![image](https://user-images.githubusercontent.com/62503531/200112159-a8958e1e-f347-4441-9c0a-3bd87818fd1b.png)
Добавим несколько записей в коллекцию
```
db.mycol.insertMany([{_id: 1, product: "product_1"}, {_id: 2, product: "product_2"}])
```
![image](https://user-images.githubusercontent.com/62503531/200112314-d591e90e-be7e-4520-bb37-e01ff59150a9.png)

Сделаем запрос на получение товара из коллекции
```
db.mycol.find({"_id": 2})
```
![image](https://user-images.githubusercontent.com/62503531/200112403-5c4d8a10-726c-4ae4-89c3-39abd56eb0b8.png)
Сделаем update и проверим результат
![image](https://user-images.githubusercontent.com/62503531/200112501-e83a1de2-6944-4c7e-8579-1ddd57684a73.png)
Удалим одну запись из коллекции
```
 db.mycol.deleteOne({"_id": 1})
 ```
 ![image](https://user-images.githubusercontent.com/62503531/200112583-983a72a4-9634-4ee8-9bd5-605340dd5e97.png)
