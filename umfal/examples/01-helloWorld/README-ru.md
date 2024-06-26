# Hello, World!
[This material is available in **English**](https://github.com/AtomicScience/atomic-programs/tree/master/umfal/examples/01-helloWorld)

Этот пример объясняет три базовых темы UMFAL:
1. Инициализация приложения
2. Составление модулей
3. Использование модулей

## Разбор кода
### init.lua
Начнем с `init.lua` - этот файл называется **точкой входа** - для запуска приложения, нужно запустить именно этот скрипт.

#### Инициализация приложения в `init.lua`
Самая первая строчка представляет интерес:
```lua
local helloWorldApp = require("umfal").initAppFromRelative("helloWorldExampleForMyAwesomeOpenComputersLibraryCalledUMFAL")
```

Просто импортировать библиотеку недостаточно - нужно также вызвать специальный метод `initAppFromRelative`, который **инициализирует приложение**

Строка-аргумент этой функции - **идентификатор** приложения, который должен отличать инициализированное приложение от других.

**Идентификатор** в данном примере абсурдно длинный, и это сделано для того, чтобы показать, что **идентификатором** может быть любая уникальная строка - рекомендуется просто использовать название приложения

#### Использование модуля в `init.lua`
После инициализации, мы можем использовать полученный объект для загрузки и использования модулей:

```lua
helloWorldApp.helloWorld.sayHelloWorld();
```
Один из плюсов UMFAL заключается в том, что мы не должны **явно** импортировать модули, как это нужно делать с `require` - модули можно просто использовать в коде!

Конечно, если вы не хотите прописывать полные пути к модулям, вы можете *"импортировать"* их следующим образом:

```lua
local helloWorld = helloWorldApp.helloWorld

helloWorld.sayHelloWorld()
```

## helloWorld.lua
Последний файл этого примера - `helloWorld.lua` - **модуль**

Его структура - такая же, как и у обычных модулей в Lua:
```lua
-- Создается пустой модуль
local helloWorld = {}

-- Функция добавляется в таблицу
function helloWorld.sayHelloWorld()
    print("Hello World!")
end

-- Модуль возвращается
return helloWorld
```