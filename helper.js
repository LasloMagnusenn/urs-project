// function printNumbers(count) {
//     const numbers = Array.from({ length: count }, (_, index) => index + 1);
//     const result = numbers.join(",");
//     console.log(result);
//   }
  
//   // Пример вызова функции с количеством элементов 10
//   printNumbers(100);


function logNumbersInRange(start, end) {
  if (typeof start !== 'number' || typeof end !== 'number' || start > end) {
    console.error('Некорректные аргументы');
    return;
  }

  const numbersArray = Array.from({ length: end - start + 1 }, (_, index) => start + index);
  console.log(numbersArray.join(','));
}

// Пример вызова функции с периодом от 5 до 10


logNumbersInRange(1, 10);
logNumbersInRange(11, 20);
logNumbersInRange(21, 30);
logNumbersInRange(31, 40);
logNumbersInRange(41, 50);
logNumbersInRange(51, 60);
logNumbersInRange(61, 70);
logNumbersInRange(71, 80);
logNumbersInRange(81, 90);
logNumbersInRange(91, 100);
logNumbersInRange(101, 110);
logNumbersInRange(111, 120);
logNumbersInRange(121, 130);
logNumbersInRange(131, 140);
logNumbersInRange(141, 150);