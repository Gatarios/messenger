# messenger
Краткое описание:

Программа для чата в windows CMD


Описание:

Позволяет связать несколько клиентов в одной комнате для переписки. То есть можно использовать интернет для обмена сообщениями таким образом.


Примечания:

0. Код написан на языке Pascal;
1. Используется командная строка Windows;
2. Данная система делится на две программы: сервер и клиент;
3. Сервер принимает подключения и рассылает получаемый текст на всех подключенных клиентов;
4. Клиент подключается к серверу, и отправляет на него текст написанный пользователем;
5. Статус соединения с сервером отображается в UI клиента;
6. При потере соединения клиент сам его восстановит если сервер станет доступен;
7. Клиент при запуске будет пытаться подключиться, пока сервер не станет доступен;
8. Серверу необходимо указать только порт, на котором ему работать;
9. Клиенту необходимо указать IP адрес компьютера, на котором находится сервер, также указать порт сервера и имя (имеется ввиду любое имя на латинице);
10. Текст сообщений может быть написан как на латинице, так и русскими буквами.


Инструкция:

0. Запустить сервер на компьютере (не забыть дать серверу порт для работы);
1. На любом компьютере имеющим сеть запустить клиент (клиенту указать адрес компьютера сервера и порт сервера, а также имя клиента);
2. Повторить пункт 1 с другими компьютерами;
3. ...
4. PROFIT.


Возможные проблемы:

0. Если Вы пытаетесь подключиться из интернета, но ничего не выходит - скорее всего либо у сервера серый IP адрес, либо соединение блокируется роутером (маршрутизатором);
1. Если клиент с сервером в одной сети и подключение не удаётся, то скорее всего необходимо указаный Вами порт разрешить в Firewall Windows;
2. Пункты 1 и 2 можно рассматривать вместе.


Create by Gatarios
