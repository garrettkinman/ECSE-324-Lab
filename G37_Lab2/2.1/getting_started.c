int main() {
	int a[5] = {1, 20, 3, 4, 5};
	int min_val = a[0];
	int i;
	for(i = 0; i < sizeof(a) / sizeof(a[0]); i++) {
		if(a[i] < min_val) {
			min_val = a[i];
		}
	}
	printf("%d", min_val);
	return min_val;
}
