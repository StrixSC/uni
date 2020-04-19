// Les patterns ici ont été trouvé de l'internet ou bien écrit par nous et tester beaucoup avant d'être ajouté.

export const REGEXP_EMAIL_PATTERN: RegExp = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
export const REGEXP_PASSWD_PATTERN: RegExp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
export const PASS_PATTERN: string = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"
export const PASS_MIN_LENGTH: number = 4;
export const PASS_MAX_LENGTH: number = 32;
export const REGEXP_CITY_PATTERN: RegExp = /^[a-zA-Z]+(?:[\s-][a-zA-Z]+)*$/
export const REGEXP_NAME_PATTERN: RegExp = /^([a-zA-Z0-9]+|[a-zA-Z0-9]+\s{1}[a-zA-Z0-9]{1,}|[a-zA-Z0-9]+\s{1}[a-zA-Z0-9]{3,}\s{1}[a-zA-Z0-9]{1,})$/
export const REGEXP_FILTER: RegExp = /[^a-zA-Z0-9]/;    // Use this to sanitize input and return false if the input contains unwanted characters.
export const REGEXP_STREET_PATTERN: RegExp = /^[a-zA-Z0-9\ ]+$/
export const REGEXP_TIME_PATTERN: RegExp = /\d\d\:\d\d:\d\d/;
export const REGEXP_DATE_PATTERN: RegExp = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/;
export const REGEXP_TITLE_PATTERN: RegExp = /^[a-zA-Z0-9_.\-\!\?\: ]*$/;
export const REGEXP_POSTAL_CODE_PATTERN: RegExp = /^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1}\d{1}[A-Za-z]{1}\d{1}$/