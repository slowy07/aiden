align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

include_unit_element_entry:
.null:
	dq STATIC_EMPTY

.header:
	dq include_unit_element_header

.label:
	dq include_unit_element_label

.draw:
	dq STATIC_EMPTY

.chain:
	dq include_unit_element_chain

.button:
	dq include_unit_element_button
