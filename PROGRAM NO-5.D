//  Objective: To implement Polynomial addition.



#include <stdio.h>
#include <stdlib.h>

struct Term {
    int coefficient;
    int exponent;
    struct Term* next;
};

struct Term* createTerm(int coef, int exp) {
    struct Term* newTerm = (struct Term*)malloc(sizeof(struct Term));

    newTerm->coefficient = coef;
    newTerm->exponent = exp;
    newTerm->next = NULL;

    return newTerm;
}

void insertTerm(struct Term** poly, int coef, int exp) {
    struct Term* newTerm = createTerm(coef, exp);

    if (*poly == NULL) {
        *poly = newTerm;
    } else {
        struct Term* current = *poly;
        struct Term* prev = NULL;

        while (current != NULL && current->exponent > exp) {
            prev = current;
            current = current->next;
        }

        if (current != NULL && current->exponent == exp) {
            current->coefficient += coef;
            free(newTerm);
        } else {
            newTerm->next = current;

            if (prev != NULL)
                prev->next = newTerm;
            else
                *poly = newTerm;
        }
    }
}

struct Term* addPoly(struct Term* poly1, struct Term* poly2) {
    struct Term* result = NULL;

    while (poly1 != NULL && poly2 != NULL) {
        if (poly1->exponent == poly2->exponent) {
            insertTerm(&result,
                       poly1->coefficient + poly2->coefficient,
                       poly1->exponent);

            poly1 = poly1->next;
            poly2 = poly2->next;
        }
        else if (poly1->exponent > poly2->exponent) {
            insertTerm(&result, poly1->coefficient, poly1->exponent);
            poly1 = poly1->next;
        }
        else {
            insertTerm(&result, poly2->coefficient, poly2->exponent);
            poly2 = poly2->next;
        }
    }

    while (poly1 != NULL) {
        insertTerm(&result, poly1->coefficient, poly1->exponent);
        poly1 = poly1->next;
    }

    while (poly2 != NULL) {
        insertTerm(&result, poly2->coefficient, poly2->exponent);
        poly2 = poly2->next;
    }

    return result;
}

void display(struct Term* poly) {
    while (poly != NULL) {
        printf("%dx^%d", poly->coefficient, poly->exponent);

        if (poly->next != NULL)
            printf(" + ");

        poly = poly->next;
    }

    printf("\n");
}

void inputPolynomial(struct Term** poly) {
    int n, coefficient, exponent;

    printf("Enter number of terms: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        printf("Enter coefficient and exponent: ");
        scanf("%d %d", &coefficient, &exponent);

        insertTerm(poly, coefficient, exponent);
    }
}

int main() {
    struct Term* poly1 = NULL;
    struct Term* poly2 = NULL;
    struct Term* result = NULL;

    printf("Enter first polynomial:\n");
    inputPolynomial(&poly1);

    printf("Enter second polynomial:\n");
    inputPolynomial(&poly2);

    printf("\nFirst Polynomial: ");
    display(poly1);

    printf("Second Polynomial: ");
    display(poly2);

    result = addPoly(poly1, poly2);

    printf("Resultant Polynomial: ");
    display(result);

    return 0;
}
