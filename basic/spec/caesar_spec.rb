require './lib/caesar'

describe 'caesar_cipher' do
  it 'works for one character' do 
    expect(caesar_cipher('a', 2)).to eql('c')
  end

  it 'works for multiple character' do
    expect(caesar_cipher('aa', 2)).to eql('cc')
  end

  it 'works for capital letters' do
    expect(caesar_cipher('A', 2)).to eql('C')
  end

  it 'ignores non letters' do
    expect(caesar_cipher('!', 3)).to eql('!')
  end

  it 'wraps around' do
    expect(caesar_cipher('zZ', 1)).to eql('aA')
  end

  it 'does all of the above at the same time' do
    expect(caesar_cipher("What a string!", 5)).to eql('Bmfy f xywnsl!')
  end

end