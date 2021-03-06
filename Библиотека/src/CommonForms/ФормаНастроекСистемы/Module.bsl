
#Область ОбщиеФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтатистикаПоРаботеСФайлами();
	СтатистикаПоКаталогуКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьПоляПутьКФайламНаДиске();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Проверим чтобы не могли установить хранение файлов на диске но путь к папке указать не правильный
	Если НаборКонстант.МестоХраненияФайлов = Перечисления.МестаХраненияФайлов.ЛокальныйДиск Тогда
		
		ПапкаНаДиске = Новый Файл(НаборКонстант.ПутьКФайламНаДиске);
		Если Не ПапкаНаДиске.Существует() Тогда
			СообщениеПользователю = Новый СообщениеПользователю();
			СообщениеПользователю.Поле = "НаборКонстант.ПутьКФайламНаДиске";
			СообщениеПользователю.Текст = НСтр("ru = 'Каталог не найден.'");
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтатистикаПоРаботеСФайлами();
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФайлами

// В зависимости от установленного значения константы ХранитьФайлыВИнформационнойБазе устанавливает доступность
// поля ПутьКФайламНаДиске. Если файлы хранятся в базе то поле не доступно
//
// Параметры:
//  нет
//
&НаКлиенте
Процедура УстановитьДоступностьПоляПутьКФайламНаДиске()

	Если НаборКонстант.МестоХраненияФайлов = ПредопределенноеЗначение("Перечисление.МестаХраненияФайлов.ЛокальныйДиск") Тогда
		Элементы.ПутьКФайламНаДиске.Доступность = Истина;
	Иначе
		Элементы.ПутьКФайламНаДиске.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры // УстановитьДоступностьПоляПутьКФайламНаДиске()

&НаКлиенте
Процедура ХранитьФайлыВИнформационнойБазеПриИзменении(Элемент)
	
	УстановитьДоступностьПоляПутьКФайламНаДиске();
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайламНаДискеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	
	
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог для хранения файлов'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		НаборКонстант.ПутьКФайламНаДиске = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура СтатистикаПоРаботеСФайлами()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Файлы.Ссылка) КАК ВсегоЗагруженоФайлов,
		|	ЕСТЬNULL(СУММА(Файлы.Размер), 0) КАК ОбщийРазмерЗагруженныхФайлов,
		|	ЕСТЬNULL(СУММА(ВЫБОР
		|				КОГДА Файлы.МестоХранения <> &МестоХранения
		|					ТОГДА 1
		|				ИНАЧЕ 0
		|			КОНЕЦ), 0) КАК КоличествоФайловДругимМестоХранения
		|ИЗ
		|	Справочник.Файлы КАК Файлы";
		
	Запрос.Параметры.Вставить("МестоХранения", Константы.МестоХраненияФайлов.Получить());
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ВсегоЗагруженоФайлов = ВыборкаДетальныеЗаписи.ВсегоЗагруженоФайлов;
		КоличествоФайловДругимМестоХранения = ВыборкаДетальныеЗаписи.КоличествоФайловДругимМестоХранения;
		
		Если КоличествоФайловДругимМестоХранения > 0 Тогда 
			Элементы.ПеренестиФайлыВТекущееМестоХранения.Доступность = Истина;
		Иначе
			Элементы.ПеренестиФайлыВТекущееМестоХранения.Доступность = Ложь;
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.ОбщийРазмерЗагруженныхФайлов / 1024 / 1024 < 1 Тогда 
			ОбщийРазмерЗагруженныхФайлов = ВыборкаДетальныеЗаписи.ОбщийРазмерЗагруженныхФайлов / 1024;
			Элементы.ДекорацияЕдиницаИзмеренияРазмераФайлов.Заголовок = НСтр("ru = 'Кб'");
		Иначе
			ОбщийРазмерЗагруженныхФайлов = ВыборкаДетальныеЗаписи.ОбщийРазмерЗагруженныхФайлов / 1024 / 1024;
			Элементы.ДекорацияЕдиницаИзмеренияРазмераФайлов.Заголовок = НСтр("ru = 'Мб'");
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // СтатистикаПоРаботеСФайлами()

&НаСервере
Процедура ПеренестиФайлыВТекущееМестоХраненияНаСервере() Экспорт
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.Ссылка КАК Файл
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.МестоХранения <> &МестоХранения";
	
	Запрос.УстановитьПараметр("МестоХранения", Константы.МестоХраненияФайлов.Получить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РаботаСФайламиСервер.ПеренестиФайл(ВыборкаДетальныеЗаписи.Файл, Константы.МестоХраненияФайлов.Получить());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиФайлыВТекущееМестоХранения(Команда)
	
	Если Модифицированность Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Перед операцией необходимо записать изменения'");
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если НаборКонстант.МестоХраненияФайлов = ПредопределенноеЗначение("Перечисление.МестаХраненияФайлов.ЛокальныйДиск") Тогда
		ТекстВопроса = НСтр("ru = 'Все файлы хранимые в информационной базе будут перенесены на локальный диск. Продолжить?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Все файлы хранимые на локальном диске будут перенесены в информационную базу. Продолжить?'");
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПеренестиФайлыВТекущееМестоХраненияЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиФайлыВТекущееМестоХраненияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		
		ПеренестиФайлыВТекущееМестоХраненияНаСервере();
		
		СтатистикаПоРаботеСФайлами();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КаталогКниг

&НаКлиенте
Процедура ИспользоватьКаталогКнигПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьКаталогКнигНаСервере()
	
	КаталогКнигСервер.ЗаполнитьКаталогКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКаталогКниг(Команда)
	
	ЗаполнитьКаталогКнигНаСервере();
	СтатистикаПоКаталогуКниг();
	
КонецПроцедуры

&НаСервере
Процедура СтатистикаПоКаталогуКниг()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК КоличествоКнигВКаталоге
		|ИЗ
		|	РегистрСведений.КаталогКниг КАК КаталогКниг";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КоличествоКнигВКаталоге = ВыборкаДетальныеЗаписи.КоличествоКнигВКаталоге;
	КонецЦикла;

КонецПроцедуры // СтатистикаПоКаталогуКниг()

&НаСервереБезКонтекста
Процедура ОчиститьКаталогКнигНаСервере()
	
	КаталогКнигСервер.ОчиститьКаталогКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКаталогКниг(Команда)
	
	ОчиститьКаталогКнигНаСервере();
	СтатистикаПоКаталогуКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьГруппировкуКнигПриИзменении(Элемент)
	
	ОбновитьИнтерфейс = Истина;
	
КонецПроцедуры


#КонецОбласти


