#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда // Для работы толстого клиента https://its.1c.ru/db/v8std#content:680:hdoc

// Регистрирует информационную базу на сервере обслуживания, для сбора статистики
//
// Параметры
//
// Возвращаемое значение:
//   <Булево>   - <Истина есть регистрация прошла успешно>
//
Функция ЗарегистрироватьБазу() Экспорт
	// http://ghostaz.no-ip.org/maintenance_server/ws/WebService?wsdl
	URI_Запроса_WSDL = Константы.СсылкаНаОписаниеВебСервисовСервераОбслуживания.Получить();
	Пользователь = Константы.ПользовательСервераОбслуживания.Получить();
	Пароль = Константы.ПарольСервераОбслуживания.Получить();
	ПространствоИмен = Константы.ПространствоИменСервераОбслуживания.Получить();
	ИмяСервиса = Константы.ИмяСервисаСервераОбслуживания.Получить();
	ИмяПорта = Константы.ИмяПортаСервераОбслуживания.Получить();
	
	Попытка
	Определение = Новый WSОпределения(URI_Запроса_WSDL, Пользователь, Пароль);
	Прокси = Новый WSПрокси(Определение, ПространствоИмен, ИмяСервиса, ИмяПорта);
	Исключение
		Возврат 0;
	КонецПопытки;
	Прокси.Пользователь = Пользователь;
	Прокси.Пароль = Пароль;		
	УникальныйИдентификаторБазы	= Константы.УникальныйИдентификаторБазы.Получить();
	УникальныйИдентификаторБазыСтрока = "";
	// Проверяем что УИД задан, потому что 36 нулей нельзя отправлять - скажет не найдена такая база
	Если ЗначениеЗаполнено(УникальныйИдентификаторБазы) Тогда
		УникальныйИдентификаторБазыСтрока = Строка(УникальныйИдентификаторБазы);
	КонецЕсли;
	Попытка
		Результат = Прокси.Регистрация(УникальныйИдентификаторБазыСтрока,Строка(ПолучитьУникальныйИдентификаторКонфигурации()), Константы.НаименованиеОрганизации.Получить(), Константы.ВерсияКонфигурации.Получить());
	Исключение
		Возврат 0;
	КонецПопытки;
	
	// Если код результат 1 то успех и потому сохраняем УИД базы
	Если Результат.Результат = 1
		И НЕ ЗначениеЗаполнено(УникальныйИдентификаторБазы) Тогда 
		Константы.УникальныйИдентификаторБазы.Установить(Новый УникальныйИдентификатор(Результат.УникальныйИдентификаторИБ));
	КонецЕсли;
	
	Возврат Результат.Результат;
	
КонецФункции // ЗарегистрироватьБазу()

// Получает УИД конфигурации
//
// Параметры
//
// Возвращаемое значение:
//   <УникальныйИдентификатор>   - <УИД текущей конфигурации>
//
Функция ПолучитьУникальныйИдентификаторКонфигурации() 

	// УИД конфигурации Библиотека
	Возврат Новый УникальныйИдентификатор("039520a2-873d-11e2-bf02-870147516ab7");	

КонецФункции // ПолучитьУникальныйИдентификаторКонфигурации()

// Проверяет наличие обновление для данной ИБ
//
// Параметры
// Версия				- строка	- версия обновления
// ДатаВыпуска          - дата		- дата выхода обновления
// СсылкаНаОбновление   - строка	- ссылка на файл комплекта поставки
// СсылкаНаОписание     - строка	- ссылка на веб страницу с описанием обновления
// Описание             - строка	- небольшое строковое описание обновления
//
// Результат 			- число		- результат поиска обновлений:
//  0 - Ошибка выполнения веб-операции
//	1 - Обновление найдено
//  2 - Новых обновлений нет
//  3 - УникальныйИдентификаторИБ не заполнен
//  4 - УникальныйИдентификаторИБ не найден в базе
//  5 - Неизвестна версия информационной базы
//  6 - Информационная база не зарегистрирована
Функция ПроверитьОбновление(ВерсияОбновления, ДатаВыпускаОбновления, СсылкаНаОбновление, СсылкаНаОписаниеОбновления, ОписаниеОбновления) Экспорт

	РезультатКод = 0;
	
	// http://ghostaz.no-ip.org/maintenance_server/ws/WebService?wsdl
	URI_Запроса_WSDL = Константы.СсылкаНаОписаниеВебСервисовСервераОбслуживания.Получить();
	Пользователь = Константы.ПользовательСервераОбслуживания.Получить();
	Пароль = Константы.ПарольСервераОбслуживания.Получить();
	ПространствоИмен = Константы.ПространствоИменСервераОбслуживания.Получить();
	ИмяСервиса = Константы.ИмяСервисаСервераОбслуживания.Получить();
	ИмяПорта = Константы.ИмяПортаСервераОбслуживания.Получить();
	
	Попытка
		Определение = Новый WSОпределения(URI_Запроса_WSDL, Пользователь, Пароль);
		Прокси = Новый WSПрокси(Определение, ПространствоИмен, ИмяСервиса, ИмяПорта);
	Исключение
		Возврат 0;
	КонецПопытки;
	
	Прокси.Пользователь = Пользователь;
	Прокси.Пароль = Пароль;		
	УникальныйИдентификаторБазы	= Константы.УникальныйИдентификаторБазы.Получить();
	УникальныйИдентификаторБазыСтрока = "";
	// Проверяем что УИД задан, потому что 36 нулей нельзя отправлять - скажет не найдена такая база
	Если ЗначениеЗаполнено(УникальныйИдентификаторБазы) Тогда
		УникальныйИдентификаторБазыСтрока = Строка(УникальныйИдентификаторБазы);
	КонецЕсли;
	
	// Если есть уникальный идентификатор базы то обновим данные
	Попытка
		Результат = Прокси.Регистрация(УникальныйИдентификаторБазыСтрока,Строка(ПолучитьУникальныйИдентификаторКонфигурации()), Константы.НаименованиеОрганизации.Получить(), Константы.ВерсияКонфигурации.Получить());
	Исключение
	КонецПопытки;
	
	Попытка
		Результат = Прокси.ПроверитьРегистрацию(УникальныйИдентификаторБазыСтрока,Строка(ПолучитьУникальныйИдентификаторКонфигурации()), Константы.НаименованиеОрганизации.Получить(), Константы.ВерсияКонфигурации.Получить());
	Исключение
		Возврат 0;
	КонецПопытки;
	
	// Если код результат 1 значит проверка регистрации прошла удачно. можно искать обновление 
	Если Результат.Результат = 1 Тогда 
		Попытка
			Результат = Прокси.ПроверитьОбновление(УникальныйИдентификаторБазыСтрока);	
		Исключение
			Возврат 0;
		КонецПопытки;
	Иначе
		Возврат 6;
	КонецЕсли;	

	РезультатКод					= Результат.Результат;
	ВерсияОбновления 				= Результат.Версия;
	ДатаВыпускаОбновления 			= Результат.ДатаВыпуска;
	СсылкаНаОбновление 				= Результат.СсылкаНаОбновление;
	СсылкаНаОписаниеОбновления 		= Результат.СсылкаНаОписание;
	ОписаниеОбновления 				= Результат.Описание;
	
	Возврат РезультатКод;
	
КонецФункции // ПроверитьОбновление()

#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
