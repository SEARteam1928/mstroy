const createInputFile = (accept, multiple) => {
    let input = document.createElement('input');
    input.type = 'file';
    input.accept = accept;
    input.multiple = multiple;
    input.className = 'upload-js';
    input.style.display = 'none';

    return input;
};

export default (accept = '*', multiple = true) => {
    return new Promise(resolve => {
        // Создание инпута выбора файлов
        let input = createInputFile(accept, multiple);

        // Этот обработчик будет вызываться после закрытия окна выбора файлов.
        // Через 200мс после закрытия будет получать выбранные файлы из инпута и резолвить с ними промис.
        // Если окно выбора файлов было просто закрыто и файлы не были выбраны, этот обработчик так же срабатывает,
        // но в resolve придет пустой псевдомассив FileList
        const focusInHandler = () => {
            setTimeout(() => {
                let files = input.files;
                document.body.removeChild(input);
                resolve(files);
            }, 200);
        };

        document.body.addEventListener('focusin', focusInHandler, { once: true });
        document.body.appendChild(input);

        // Открытие окна выбора файлов
        setTimeout(() => {
            input.click();
        }, 66);
    });
};
