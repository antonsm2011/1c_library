#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда // Для работы толстого клиента https://its.1c.ru/db/v8std#content:680:hdoc

// Создает нового автора
//
// Параметры:
//  Наименование  - <Строка> - наименование автора
//
// Возвращаемое значение:
//   <СправочникСсылка.Авторы>   - созданное издательство
//
Функция СоздатьАвтора(Наименование) Экспорт
	
	АвторОбъект = Справочники.Авторы.СоздатьЭлемент();
	АвторОбъект.Наименование = Наименование;
	Попытка
		АвторОбъект.Записать();
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Не удалось создать автора'");
		СообщениеПользователю.Сообщить();
		ОбщегоНазначенияСервер.ЗафиксироватьОшибку(СообщениеПользователю.Текст, ОписаниеОшибки, Метаданные.Справочники.Авторы, Наименование);
	КонецПопытки;
	
	Возврат АвторОбъект.Ссылка;
	
КонецФункции // СоздатьАвтора()

#КонецЕсли
