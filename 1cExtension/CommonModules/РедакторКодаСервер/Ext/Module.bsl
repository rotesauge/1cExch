﻿Процедура ВыполнитьМодуль(СтруктураКода, ПараметрыВыполнения=Неопределено, ПараметрыАлгоритма=Неопределено) Экспорт
	Для каждого СтрокаКоллекции Из СтруктураКода Цикл
		Выполнить(СтрокаКоллекции.Значение);
	КонецЦикла;
КонецПроцедуры

Функция СформироватьСтруктуруАлгоритма(Ссылка) Экспорт
	СтруктураПараметров=Ссылка.ПараметрыАлгоритма.Получить();
	Если НЕ ТипЗнч(СтруктураПараметров)=Тип("Структура") Тогда
		СтруктураПараметров=Новый Структура;	
	КонецЕсли;
	СтруктураПараметров.Вставить("ВыполняемыйМодуль", Ссылка.Алгоритм);
	Возврат СтруктураПараметров;
КонецФункции

Процедура Инициализация() Экспорт
	КоллекцияОбщихМодулей=Новый Структура();
	КоллекцияОбщихМодулей.Вставить("МодулиОбщие", Новый Структура());
	КоллекцияОбщихМодулей.Вставить("МодулиГлобальные", Новый Структура());
	Для каждого СтрокаКоллекции Из Метаданные.ОбщиеМодули Цикл
		ИмяСвойства="Модули"+?(СтрокаКоллекции.Глобальный, "Глобальные", "Общие");
		КоллекцияОбщихМодулей[ИмяСвойства].Вставить(СтрокаКоллекции.Имя, Новый Структура());
	КонецЦикла;

	//Параметры сеанса
	СтруктураДанных=Новый Структура;
	СтруктураДанных.Вставить("МодулиОбщиеJSON", JSON_Общий.Записать(КоллекцияОбщихМодулей.МодулиОбщие));
	СтруктураДанных.Вставить("МодулиГлобальныеJSON", JSON_Общий.Записать(КоллекцияОбщихМодулей.МодулиГлобальные));
	ПараметрыСеанса.РедакторКодаДанные=Новый ФиксированнаяСтруктура(СтруктураДанных);	
КонецПроцедуры

Функция ПолучитьМакет(ИмяМакета) Экспорт
	Возврат Обработки.РедакторКода.ПолучитьМакет(ИмяМакета);
КонецФункции

Функция ПолучитьТекстМакета(ИмяМакета, УдалятьПереносыСтрок) Экспорт
	Макет=ПолучитьМакет(ИмяМакета);
	Текст=Макет.ПолучитьТекст();
	Если УдалятьПереносыСтрок Тогда
		Текст=СтрЗаменить(Текст, Символы.ПС, " ");
	КонецЕсли;	
	Возврат Текст;
КонецФункции

Функция ПараметрыТекущегоСеанса() Экспорт
	Возврат ПараметрыСеанса.РедакторКодаДанные;
КонецФункции

Функция ИмяМетаданных(ПолноеИмя)  Экспорт
	Возврат СтрПолучитьСтроку(СтрЗаменить(ПолноеИмя, ".", Символы.ПС), 1);	
КонецФункции

Функция ПолноеИмяМетаданных(ТипМетаданных, ВидМетаданных) Экспорт
	Попытка Возврат Метаданные[ТипМетаданных][ВидМетаданных].ПолноеИмя();
	Исключение Возврат "";
	КонецПопытки;	
КонецФункции

Функция СвязьСОбъектомМетаданных(Реквизит, Связи) Экспорт
	Связь=""; Индекс=0;	Типы=Реквизит.Тип.Типы();

	Пока Индекс < Типы.Количество() И НЕ ЗначениеЗаполнено(Связь) Цикл
		Тип=Типы[Индекс]; СвязьТипа=Связи[Тип];
		Если СвязьТипа=Неопределено Тогда
			ОбъектМетаданных=Метаданные.НайтиПоТипу(Тип);
			Если НЕ ОбъектМетаданных=Неопределено Тогда
				// Сейчас связи описыватьются только для справочников и документов.
				// При желании, пожертвовав скоростью получения описания всех метаданных
				// сюда же можно добавить следующие элементы:
				// Метаданные.БизнесПроцессы businessProcesses
				// Метаданные.Задачи tasks
				// Метаданные.ПланыВидовРасчета chartsOfCalculationTypes
				// Метаданные.ПланыВидовХарактеристик chartsOfCharacteristicTypes
				// Метаданные.ПланыОбмена exchangePlans
				// Метаданные.ПланыСчетов сhartsOfAccounts
				Если Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
					Связь="catalogs."+ОбъектМетаданных.Имя;
				ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
					Связь="documents."+ОбъектМетаданных.Имя;
				КонецЕсли;
			КонецЕсли;
			Связи[Тип]=Связь;			
		Иначе			
			Связь=СвязьТипа;			
		КонецЕсли;		
		Индекс=Индекс+1;		
	КонецЦикла;
	
	Возврат Связь;	
КонецФункции

Функция СписокОбъектовМетаданных(ТипОбъектов, АдресОбновления) Экспорт
	ИмяКоллекции=РедакторКодаОбщий.ИмяКоллекцииМетаданныхПоТипу(ТипОбъектов);
	Если НЕ ЗначениеЗаполнено(ИмяКоллекции) Тогда Возврат ""; КонецЕсли;
	
	СписокОбъектов=Новый Структура();
	Для каждого ОбъектМетаданных Из Метаданные[ТипОбъектов] Цикл
		СписокОбъектов.Вставить(ОбъектМетаданных.Имя, Новый Структура());
	КонецЦикла;		
	АдресОбновления=ИмяКоллекции+".items";		

	Возврат JSON_Общий.Записать(СписокОбъектов);	
КонецФункции

Функция ЗначениеКонстантыПолучить(стрКонстанта) Экспорт
	Возврат Константы[стрКонстанта].Получить();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Проверка объектов метаданных

Функция ОбъектМетаданныхИмеетСтандартныеРеквизиты(ПолноеИмя) Экспорт
	Объекты=Новый Массив();
	Объекты.Добавить("Справочник");
	Объекты.Добавить("Документ");
	Объекты.Добавить("БизнесПроцесс");
	Объекты.Добавить("Задача");
	
	Возврат НЕ Объекты.Найти(ИмяМетаданных(ПолноеИмя))=Неопределено;	
КонецФункции

Функция ОбъектМетаданныхИмеетИзмерения(ПолноеИмя) Экспорт
	Объекты=Новый Массив();
	Объекты.Добавить("РегистрСведений");
	Объекты.Добавить("РегистрНакопления");
	Объекты.Добавить("РегистрБухгалтерии");
	Объекты.Добавить("РегистрРасчета");
	
	Возврат НЕ Объекты.Найти(ИмяМетаданных(ПолноеИмя))=Неопределено;	
КонецФункции

Функция ОбъектМетаданныхИмеетПредопределенные(ПолноеИмя) Экспорт
	Объекты=Новый Массив();
	Объекты.Добавить("Справочник");
	Объекты.Добавить("ПланСчетов");	
	Объекты.Добавить("ПланВидовХарактеристик");
	Объекты.Добавить("ПланВидовРасчета");
	
	Возврат НЕ Объекты.Найти(ИмяМетаданных(ПолноеИмя))=Неопределено;	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Описание объектов метаданных

Функция ОписаниеОбъектаМетаданных(ТипОбъекта, АдресОбновления) Экспорт
	Части=СтрРазделить(ТипОбъекта, "."); //документы.поступлениетоваровуслуг

	ИмяКоллекции=РедакторКодаОбщий.ИмяКоллекцииМетаданныхПоТипу(Части[0]);
	Если НЕ ЗначениеЗаполнено(ИмяКоллекции) Тогда Возврат ""; КонецЕсли;
	
	ОписаниеРеквизитов=Новый Структура();
	ОписаниеРесурсов=Новый Структура();
	ОписаниеПредопределенных=Новый Структура();
	ОписаниеТабличныхЧастей=Новый Структура();
	ДополнительныеСвойства=Новый Структура();

	Связи=Новый Соответствие();		
	ОбъектМетаданных=Метаданные[Части[0]][Части[1]];
	ПолноеИмя=ОбъектМетаданных.ПолноеИмя();
	
	Если ИмяМетаданных(ПолноеИмя)="Перечисление" Тогда
		ЗаполнитьОписаниеЗначенийПеречисления(ОбъектМетаданных, ОписаниеРеквизитов);
	Иначе
		ЗаполнитьОписаниеРеквизитов(ОбъектМетаданных, ОписаниеРеквизитов, Связи);
		ЗаполнитьОписаниеСтандартныхРеквизитов(ОбъектМетаданных, ПолноеИмя, ОписаниеРеквизитов, Связи);
		ЗаполнитьОписаниеПредопределенныхЭлементов(ОбъектМетаданных, ПолноеИмя, ОписаниеПредопределенных);
		ЗаполнитьОписаниеИзмеренийРесурсов(ОбъектМетаданных, ПолноеИмя,	ОписаниеРеквизитов, ОписаниеРесурсов, ДополнительныеСвойства, Связи);
		ЗаполнитьОписаниеТабличныхЧастей(ОбъектМетаданных, ПолноеИмя, ОписаниеРеквизитов, ОписаниеТабличныхЧастей, Связи);
	КонецЕсли;
	
	СтруктураОбъекта=Новый Структура();
	СтруктураОбъекта.Вставить("properties", ОписаниеРеквизитов);
	
	Для Каждого СтрокаКоллекции Из ДополнительныеСвойства Цикл
		СтруктураОбъекта.Вставить(СтрокаКоллекции.Ключ, СтрокаКоллекции.Значение);
	КонецЦикла;
	
	Если НЕ ОписаниеРесурсов.Количество()=0 Тогда
		СтруктураОбъекта.Вставить("resources", ОписаниеРесурсов);
	КонецЕсли;
	
	Если НЕ ОписаниеПредопределенных.Количество()=0 Тогда
		СтруктураОбъекта.Вставить("predefined", ОписаниеПредопределенных); 
	КонецЕсли;
	
	Если НЕ ОписаниеТабличныхЧастей.Количество()=0 Тогда
		СтруктураОбъекта.Вставить("tabulars", ОписаниеТабличныхЧастей); 
	КонецЕсли;
	
	АдресОбновления=ИмяКоллекции+".items."+ОбъектМетаданных.Имя;

	Возврат JSON_Общий.Записать(СтруктураОбъекта);	
КонецФункции

Процедура ЗаполнитьТипРегистра(ДополнительныеСвойства, ОбъектМетаданных, ПолноеИмя) Экспорт
	ИмяМетаданных=ИмяМетаданных(ПолноеИмя); ТипРегистра="";
	Если ИмяМетаданных="РегистрСведений" Тогда
		Периодический=ОбъектМетаданных.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
		ТипРегистра=?(Периодический, "periodical", "nonperiodical");

	ИначеЕсли ИмяМетаданных="РегистрНакопления" Тогда
		ТипРегистра=?(ОбъектМетаданных.ВидРегистра=Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки, "balance", "turnovers");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипРегистра) Тогда
		ДополнительныеСвойства.Вставить("type", ТипРегистра);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьОписаниеПредопределенныхЭлементов(ОбъектМетаданных, ПолноеИмя, ОписаниеПредопределенных) Экспорт
	Если ОбъектМетаданныхИмеетПредопределенные(ПолноеИмя) Тогда
		Если ИмяМетаданных(ПолноеИмя)="ПланСчетов" Тогда
			Запрос=Новый Запрос;
			Запрос.Текст="
			|ВЫБРАТЬ
			|	ИсточникДанных.Код КАК Код,
			|	ИсточникДанных.ИмяПредопределенныхДанных КАК Имя
			|ИЗ
			|	"+ПолноеИмя+" КАК ИсточникДанных
			|ГДЕ
			|	ИсточникДанных.Предопределенный
			|";			
			Выборка=Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл 
				ОписаниеПредопределенных.Вставить(Выборка.Имя, СтрШаблон("%1 (%2)", Выборка.Имя, Выборка.Код));
			КонецЦикла;
		Иначе
			Предопределенные=ОбъектМетаданных.ПолучитьИменаПредопределенных();
			Для Каждого Имя Из Предопределенные Цикл
				ОписаниеПредопределенных.Вставить(Имя, "");
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьОписаниеИзмеренийРесурсов(ОбъектМетаданных, ПолноеИмя, ОписаниеРеквизитов, ОписаниеРесурсов, ДополнительныеСвойства, Связи) Экспорт
	Если НЕ ОбъектМетаданныхИмеетИзмерения(ПолноеИмя) Тогда Возврат; КонецЕсли;
		
	Для каждого мдИзмерение Из ОбъектМетаданных.Измерения Цикл
		ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, мдИзмерение, Связи);
	КонецЦикла;

	Для каждого мдРесурс Из ОбъектМетаданных.Ресурсы Цикл	
		ДобавитьОписаниеРеквизита(ОписаниеРесурсов, мдРесурс, Связи);
	КонецЦикла;

	ЗаполнитьТипРегистра(ДополнительныеСвойства, ОбъектМетаданных, ПолноеИмя);
КонецПроцедуры

Процедура ЗаполнитьОписаниеТабличныхЧастей(ОбъектМетаданных, ПолноеИмя, ОписаниеРеквизитов, ОписаниеТабличныхЧастей, Связи) Экспорт
	Для каждого мдТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
		ОписаниеРеквизитов.Вставить(мдТабличнаяЧасть.Имя, Новый Структура("name", "ТЧ: "+мдТабличнаяЧасть.Представление()));
		
		ОписаниеТабличнойЧасти=Новый Структура();
		
		Для Каждого мдРеквизит Из мдТабличнаяЧасть.СтандартныеРеквизиты Цикл
			ОписаниеТабличнойЧасти.Вставить(мдРеквизит.Имя, мдРеквизит.Синоним);
		КонецЦикла;
		
		Для Каждого мдРеквизит Из мдТабличнаяЧасть.Реквизиты Цикл
			ДобавитьОписаниеРеквизита(ОписаниеТабличнойЧасти, мдРеквизит, Связи);
		КонецЦикла;

		СтруктураТабличнойЧасти=Новый Структура();
		СтруктураТабличнойЧасти.Вставить("properties", ОписаниеТабличнойЧасти);
		
		Если НЕ ОписаниеТабличнойЧасти.Количество()=0 Тогда
			ОписаниеТабличныхЧастей.Вставить(мдТабличнаяЧасть.Имя, СтруктураТабличнойЧасти);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьОписаниеРеквизитов(ОбъектМетаданных, ОписаниеРеквизитов, Связи) Экспорт
	Для каждого мдРеквизит Из ОбъектМетаданных.Реквизиты Цикл
		ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, мдРеквизит, Связи);
	КонецЦикла;	
КонецПроцедуры

Процедура ЗаполнитьОписаниеСтандартныхРеквизитов(ОбъектМетаданных, ПолноеИмя, ОписаниеРеквизитов, Связи) Экспорт
	Если ОбъектМетаданныхИмеетСтандартныеРеквизиты(ПолноеИмя) Тогда
		Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
			ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, Связи);
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьОписаниеЗначенийПеречисления(ОбъектМетаданных, ОписаниеРеквизитов) Экспорт
	Для каждого мдРеквизит Из ОбъектМетаданных.ЗначенияПеречисления.Реквизиты Цикл
		ОписаниеРеквизитов.Вставить(мдРеквизит.Имя, Новый Структура("name", мдРеквизит.Представление()));
	КонецЦикла;	
КонецПроцедуры

Процедура ДобавитьОписаниеРеквизита(ОписаниеРеквизитов, Реквизит, Связи) Экспорт
	Связь=?(НЕ Связи=Неопределено, СвязьСОбъектомМетаданных(Реквизит, Связи), "");
	ОписаниеРеквизита=Новый Структура("name", Реквизит.Синоним);
	
	Если ЗначениеЗаполнено(Связь) Тогда
		ОписаниеРеквизита.Вставить("ref", Связь);
	КонецЕсли;
	
	ОписаниеРеквизитов.Вставить(Реквизит.Имя, ОписаниеРеквизита);	
КонецПроцедуры