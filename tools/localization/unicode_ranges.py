from typing import List, Union, Tuple, Iterable

class UnicodeRanges:
    def __init__(self, ranges: List[Union[int, Tuple[int, int]]] = None):
        # Initialize the ranges as an empty list of tuples (start, end)
        if ranges is None:
            ranges: List[Tuple[int, int]] = []
        # Convert any single integers to tuples
        ranges = [(r, r) if isinstance(r, int) else r for r in ranges]
        self._ranges = []
        self.add_ranges(ranges)

    def _merge_in_place(self, start: int, end: int, insert_index: int):
        """Merge the new range in place starting at insert_index."""
        n = len(self._ranges)
        i = insert_index

        # Expand the start and end if overlapping or contiguous ranges are found
        while i < n and self._ranges[i][0] <= end + 1:
            start = min(start, self._ranges[i][0])
            end = max(end, self._ranges[i][1])
            i += 1

        # Replace the current range and delete any overlapped ranges
        self._ranges[insert_index: i] = [(start, end)]

    def add_ranges(self, ranges: Iterable[Tuple[int, int]]):
        for start, end in ranges:
            self.add_range(start, end)

    def add_range(self, start: int, end: int):
        """Add a new range (start, end) while maintaining sorted order and merging if necessary."""
        if start > end:
            start, end = end, start

        n = len(self._ranges)
        i = 0

        # Find the insertion point
        while i < n and self._ranges[i][1] < start - 1:
            i += 1

        # Merge the new range into the correct position
        self._merge_in_place(start, end, i)

    def add_ordinal(self, ordinal: int):
        """Add a single ordinal and merge it with existing ranges if necessary."""
        self.add_range(ordinal, ordinal)

    def add_ordinals(self, ordinals: Iterable[int]):
        """Add a list of ordinals and merge them with existing ranges if necessary."""
        for ordinal in ordinals:
            self.add_ordinal(ordinal)

    def get_ranges(self) -> List[Tuple[int, int]]:
        return self._ranges

    def merge(self, other):
        for start, end in other.get_ranges():
            self.add_range(start, end)
        return self

    def get_unicode_ranges_string(self):
        def int_to_hex(i: int) -> str:
            return hex(i)[2:].upper()
        parts = []
        for unicode_range in self._ranges:
            parts.append(f'{int_to_hex(unicode_range[0])}-{int_to_hex(unicode_range[1])}')
        return ','.join(parts)

    def contains_ordinal(self, ordinal: int) -> bool:
        for start, end in self._ranges:
            if start <= ordinal <= end:
                return True
        return False

    def contains_range(self, start: int, end: int) -> bool:
        for s, e in self._ranges:
            if s <= start and end <= e:
                return True
        return False

    def iter_ordinals(self) -> Iterable[int]:
        for start, end in self._ranges:
            yield from range(start, end + 1)

    def intersect(self, other: 'UnicodeRanges') -> 'UnicodeRanges':
        """
        Get the intersection of two unicode ranges, returning a new UnicodeRanges object that contains the ordinals that
        are in both ranges.
        """
        # TODO: this is pretty inefficient to be iterating over all ordinals.
        result = UnicodeRanges()
        for ordinal in self.iter_ordinals():
            if other.contains_ordinal(ordinal):
                result.add_ordinal(ordinal)
        return result