# data_utils.py

def clean_data(data):
    """데이터 정제 함수"""
    return [x.strip().lower() for x in data]

def save_to_file(data, filename):
    """파일 저장 함수"""
    with open(filename, 'w') as f:
        f.write('\n'.join(data))

# 직접 실행: 특정 파일을 처리하는 스크립트로 동작
if __name__ == "__main__":
    raw_data = ["  Apple  ", "BANANA", "  Cherry  "]
    cleaned = clean_data(raw_data)
    save_to_file(cleaned, "output.txt")
    print("처리 완료!")
