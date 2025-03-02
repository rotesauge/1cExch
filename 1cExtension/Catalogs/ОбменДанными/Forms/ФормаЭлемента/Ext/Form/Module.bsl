﻿
&НаСервере
Процедура ПосмотретьТелоЗапросаНаСервере()
	Тд.Очистить();
	Тд.УстановитьТекст(Объект.ТелоСообщения);
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьТелоЗапроса(Команда)
	ПосмотретьТелоЗапросаНаСервере(); 
КонецПроцедуры

&НаСервере
Процедура ПосмотретьТелоОтветаНаСервере()
	Тд.Очистить();
	Тд.УстановитьТекст(Объект.ТелоОтвета);
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьТелоОтвета(Команда)
	ПосмотретьТелоОтветаНаСервере();
	
КонецПроцедуры


&НаСервере
Процедура ПриОткрытииНаСервере()
	
	// ГУИД = 05dbe824-a4c6-11dd-bf56-00145e3710ab  
	
	// Ссылка будет установлена в переменную СсылкаНаОбъектГуид
	Попытка
		НачатьТранзакцию();
		УИД = Новый УникальныйИдентификатор(Объект.Объект);
		
		// все объекты по которым можно получить ссылку
		СсылкаНаОбъект = Неопределено;
		
		Если ПолучитьСсылкуНоМенеджеруОбъекта(Справочники,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(Документы,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыВидовХарактеристик,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыСчетов,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыОбмена,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(БизнесПроцессы,УИД,СсылкаНаОбъект) Тогда
			
		ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(Задачи,УИД,СсылкаНаОбъект) Тогда
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Ошибка=ОписаниеОшибки();
	КонецПопытки;
	
	
	ЭтаФорма.СсылкиНаОбъекты.Очистить();
	Для каждого СтрокаО Из Объект.Объекты Цикл
		Попытка
			НачатьТранзакцию();
			УИД = Новый УникальныйИдентификатор(СтрокаО.Объект);
			
			// все объекты по которым можно получить ссылку
			СсылкаНаОбъект1 = Неопределено;
			
			Если ПолучитьСсылкуНоМенеджеруОбъекта(Справочники,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(Документы,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыВидовХарактеристик,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыСчетов,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(ПланыОбмена,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(БизнесПроцессы,УИД,СсылкаНаОбъект1) Тогда
				
			ИначеЕсли ПолучитьСсылкуНоМенеджеруОбъекта(Задачи,УИД,СсылкаНаОбъект1) Тогда
				
			КонецЕсли;
			
			СтрокаОбъект = ЭтаФорма.СсылкиНаОбъекты.Добавить();
			СтрокаОбъект.СсылкаНаОбъект = СсылкаНаОбъект1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			Ошибка=ОписаниеОшибки();
		КонецПопытки;
		
		
	КонецЦикла;
	
	
	
	Попытка
		НачатьТранзакцию();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ЭтаФорма.Объект.ТелоСообщения);
		НашиДанныеJSON = ПрочитатьJSON(ЧтениеJSON,Истина);
		НашиДанныеJSON =  ргОбменДаннымиОбработкаВходящиеСервер.ПолучитьСтруктуруИзСоответствия(НашиДанныеJSON); 
		ЧтениеJSON.Закрыть();
		
		ДеревоЗначений= новый ДеревоЗначений;
		ДеревоЗначений.Колонки.Добавить("Ключ");
		ДеревоЗначений.Колонки.Добавить("Значение");
		ВерхнийУровеньдерева=ДеревоЗначений.Строки.Добавить();
		ВерхнийУровеньдерева.Ключ="Структура JSON";    
		СформироватьДерево(НашиДанныеJSON,ВерхнийУровеньдерева);
		
		ЗначениеВДанныеФормы(ДеревоЗначений, Дерево);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Ошибка=ОписаниеОшибки();
	КонецПопытки;
	
	// ПолучитьСсылкуНоМенеджеруОбъекта()
КонецПроцедуры



&НаСервере
Функция СформироватьДерево(НашаСтруктура,ТекущееДерево)
	
	Для каждого СтрокаСтруктуры из НашаСтруктура цикл	
		Если ТипЗнч(СтрокаСтруктуры)=Тип("КлючИЗначение") тогда
			ПодчиненнаяСтрока=ТекущееДерево.Строки.Добавить();
			ПодчиненнаяСтрока.Ключ=СтрокаСтруктуры.Ключ;	
			
			Если ТипЗнч(СтрокаСтруктуры.Значение)=Тип("Структура") или ТипЗнч(СтрокаСтруктуры.Значение)=Тип("Соответствие") или ТипЗнч(СтрокаСтруктуры.Значение)=Тип("Массив")  тогда			
				СформироватьДерево(СтрокаСтруктуры.Значение,ПодчиненнаяСтрока)
			Иначе
				ПодчиненнаяСтрока.Значение=СтрокаСтруктуры.Значение;          
			КонецЕсли;
		ИначеЕсли ТипЗнч(СтрокаСтруктуры)=Тип("Структура") или ТипЗнч(СтрокаСтруктуры)=Тип("Соответствие") или ТипЗнч(СтрокаСтруктуры)=Тип("Массив")  тогда	
			ПодчиненнаяСтрока=ТекущееДерево.Строки.Добавить();
			ПодчиненнаяСтрока.Ключ="";
			ПодчиненнаяСтрока.Значение="[...]";
			СформироватьДерево(СтрокаСтруктуры,ПодчиненнаяСтрока);
		Иначе
			ПодчиненнаяСтрока=ТекущееДерево.Строки.Добавить();
			ПодчиненнаяСтрока.Значение=СтрокаСтруктуры;	   
		КонецЕсли;
	КонецЦикла;
	
КонецФункции


&НаСервереБезКонтекста
Функция ПолучитьСсылкуНоМенеджеруОбъекта(ОбъектыМенеджер,УникальныйИдентификатор,Ссылка = Неопределено)
	Ссылка = Неопределено;
	Для Каждого Менеджер Из ОбъектыМенеджер Цикл
		
		СсылкаНаОбъектГуид = Менеджер.ПолучитьСсылку(УникальныйИдентификатор);
		
		Если СсылкаНаОбъектГуид.ПолучитьОбъект() <> Неопределено Тогда
			Ссылка = СсылкаНаОбъектГуид;
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	
	Возврат Ложь;
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПерезапуститьНаСервере()
	ЭтаФорма.Объект.Ошибка = "";	// Вставить содержимое обработчика.
	ЭтаФорма.Объект.ТочкаМаршрута = Перечисления.ОбменДаннымиТочкиМаршрута.Новое;	// Вставить содержимое обработчика.
	ЭтаФорма.Объект.ЕстьОшибка = Ложь;	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить(Команда)
	ПерезапуститьНаСервере();
КонецПроцедуры
