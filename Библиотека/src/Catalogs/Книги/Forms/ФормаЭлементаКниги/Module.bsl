&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Определим расположение книги
	РасположениеКниги = Строка(Справочники.Книги.ПолучитьРасположениеКниги(Объект.Ссылка));
	Если РасположениеКниги="" Тогда
		ЭтаФорма.Элементы.ДекорацияНадписьСамоРасположение.Заголовок = "Неизвестно ";
		ЭтаФорма.Элементы.ДекорацияНадписьСамоРасположение.ЦветТекста = Новый Цвет(255,0,0);
	Иначе
		ЭтаФорма.Элементы.ДекорацияНадписьСамоРасположение.Заголовок = РасположениеКниги + " ";
	КонецЕсли;
	
	Элементы.ГруппаКниг.Видимость = Константы.ИспользоватьГруппировкуКниг.Получить();
	
	ОтобразитьОбложку();
	
КонецПроцедуры

&НаКлиенте
Процедура ИздательПриИзменении(Элемент)
	
	Автор="";
	Если  Объект.Авторы.Количество()>0 Тогда
		Автор =  Строка(Объект.Авторы[0].Автор) + " ";
	КонецЕсли;
	
	Объект.ПолноеНаименование = Объект.Наименование + " " + Автор + Объект.Издательство + " стр." + Объект.Страниц;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнвентарныйНомер(Команда)
	
	ИнвНомер = ВызватьУстановкуИнвентарногоНомераНаСервере(Объект.Ссылка);
	Объект.ИнвентарныйНомер = ИнвНомер;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ВызватьУстановкуИнвентарногоНомераНаСервере(Книга)
	
	ИнвентарныйНомер = ОбщегоНазначенияСервер.ПолучитьМаксимальныйИнвентарныйНомерКниги(Книга);
	
	Если ПустаяСтрока(ИнвентарныйНомер) Тогда
		ИнвентарныйНомер = "0";
	КонецЕсли;
	
	// Уберем из номера буквы
	ИнвентарныйНомерБезБукв = "";
	Для Индекс = 1 По СтрДлина(ИнвентарныйНомер) Цикл
		ТекущийСимвол = Сред(ИнвентарныйНомер, Индекс, 1);
		Если СтрНайти("1234567890", ТекущийСимвол) > 0 Тогда
			ИнвентарныйНомерБезБукв = ИнвентарныйНомерБезБукв + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	// Переведем строку без букв в число и добавим единицу
	ИнвентарныйНомерЧисло = Число(ИнвентарныйНомерБезБукв) + 1;
	// Переведем обратно в строку, что бы можно было эти цифры выбрать
	ИнвентарныйНомерБезБукв = Строка(ИнвентарныйНомерЧисло);
	
	НовыйИнвентарныйНомер = "";
	
	// Будем на места цифр в исходном инв.номере вставлять новое число
	ИндексЧисла = 1;
	Для Индекс = 1 По СтрДлина(ИнвентарныйНомер) Цикл
		ТекущийСимвол = Сред(ИнвентарныйНомер, Индекс, 1);
		Если СтрНайти("1234567890", ТекущийСимвол) > 0 Тогда
			НовыйИнвентарныйНомер = НовыйИнвентарныйНомер + Сред(ИнвентарныйНомерБезБукв, ИндексЧисла, 1);
			ИндексЧисла = ИндексЧисла + 1;
		Иначе
			НовыйИнвентарныйНомер = НовыйИнвентарныйНомер + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	// Если не все числа были перенесены обратно в номер, то добавляем их в конец строки. Это возможно когда увеличение на вызвало увеличение порядка
	Если ИндексЧисла < СтрДлина(ИнвентарныйНомерБезБукв) + 1 Тогда
		НовыйИнвентарныйНомер = НовыйИнвентарныйНомер + Сред(ИнвентарныйНомерБезБукв, ИндексЧисла);
	КонецЕсли;
	
	Возврат НовыйИнвентарныйНомер;
	
КонецФункции

#Область РаботаСФайлами

&НаКлиенте
Процедура ДекорацияОчиститьНажатие(Элемент)
	
	Объект.Обложка = Неопределено;
	ЭтотОбъект.Модифицированность = Истина; // Почему то модифицированность автоматом не ставится
	ОтобразитьОбложку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗагрузитьНажатие(Элемент)
	
	РаботаСФайламиКлиент.ЗагрузитьФайл(Новый ОписаниеОповещения("ЗавершениеЗагрузкиФайла", ЭтотОбъект), УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузкиФайла(Файл, ДополнительныеПараметры) Экспорт
	
	Объект.Обложка = Файл;	
	ЭтотОбъект.Модифицированность = Истина; // Почему то модифицированность автоматом не ставится	
	ОтобразитьОбложку();
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОбложку()
	
	Если ЗначениеЗаполнено(Объект.Обложка) Тогда 
		Обложка = РаботаСФайламиСервер.ПоместитьФайлВоВременноеХранилище(Объект.Обложка, УникальныйИдентификатор);
	Иначе
		Обложка = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.ИзображениеКниги.ПолучитьДвоичныеДанные(), УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры // ОтобразитьОбложку()

#КонецОбласти