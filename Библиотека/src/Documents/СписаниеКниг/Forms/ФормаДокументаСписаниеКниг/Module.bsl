
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Для Каждого СтрокаТЧ Из Объект.Книги Цикл
		СтрокаТЧ.Авторы = ПолучитьСтрокуАвторовВызов(СтрокаТЧ.Книга);
	КонецЦикла;

КонецПроцедуры

// При изменении строки перечитываем авторов
&НаКлиенте
Процедура КнигиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Элемент.ТекущиеДанные.Авторы = ПолучитьСтрокуАвторовВызов(Элемент.ТекущиеДанные.Книга);
	
КонецПроцедуры

// Данная функция предназначена для вызова функции(серв) общего глобального модуля
// Потому что я еще не понял как из клиентской процедуры модуля управляемой формы
// Вызвать серверную процедуру общего глобального модуля
&НаСервереБезКонтекста
Функция ПолучитьСтрокуАвторовВызов(СсылкаНаКнигу)
	
	Возврат ОбщегоНазначенияСервер.ПолучитьСтрокуАвторов(СсылкаНаКнигу);
	
КонецФункции

&НаКлиенте
Процедура ПодборКниг(Команда)
	
	ПараметрыПодбора = Новый Структура("МножественныйВыбор", Истина);
	ОткрытьФорму("Справочник.Книги.ФормаВыбора", ПараметрыПодбора, Элементы.Книги);
	
КонецПроцедуры

&НаКлиенте
Процедура КнигиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыбранныеКниги = РазложитьГруппыКниг(ВыбранноеЗначение);
	
	Для Каждого Книга Из ВыбранныеКниги Цикл
		НоваяСтрока = Объект.Книги.Добавить();
		НоваяСтрока.Книга = Книга;
		НоваяСтрока.Авторы = ПолучитьСтрокуАвторовВызов(Книга);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазложитьГруппыКниг(СписокКнигСГруппами)
	Возврат ОбщегоНазначенияСервер.РазложитьГруппыКниг(СписокКнигСГруппами);
КонецФункции