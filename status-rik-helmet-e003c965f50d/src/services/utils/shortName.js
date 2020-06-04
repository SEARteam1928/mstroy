import capitalize from './capitalize';

export default (lastName, firstName, surname, fullName = false) => {
    let result = '';

    if (lastName) result += capitalize(lastName);
    if (firstName) result += fullName ? ` ${capitalize(firstName)}` : ` ${firstName[0].toUpperCase()}.`;
    if (surname) result += fullName ? ` ${capitalize(surname)}` : `${surname[0].toUpperCase()}.`;

    return result;
};
