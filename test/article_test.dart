import 'package:arxiv_mobile/models/article.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

void main() {
  test('Conversion from JSON mapping', () {
    final json = {
      'id': 'cond-mat/0002322v1',
      'updated': DateTime.parse('2000-02-21T11:53:06Z'),
      'published': DateTime.parse('2000-02-21T11:54:06Z'),
      'title':
          'First-principles calculations of hot-electron lifetimes in metals',
      'summary':
          'First-principles calculations of the inelastic lifetime of low-energy electrons in Al, Mg, Be, and Cu are reported.',
      'authors': ['I. Campillo', 'V. M. Silkin', 'J. M. Pitarke'],
      'doi': '10.1103/PhysRevB.61.13484',
      'doiUrl': 'http://dx.doi.org/10.1103/PhysRevB.61.13484',
      'comment': '8 pages, 10 figures, to appear in Phys. Rev. B',
      'journalRef': 'Phys. Rev. B 61, 13484 (2000)',
      'categories': ['cond-mat.mtrl-sci'],
      'articleUrl': 'http://arxiv.org/abs/cond-mat/0002322v1',
      'pdfUrl': 'http://arxiv.org/pdf/cond-mat/0002322v1',
    };

    final article = Article.fromJson(json);

    expect(article.id, 'cond-mat/0002322v1');
    expect(article.updated, DateTime.parse('2000-02-21T11:53:06Z'));
    expect(article.published, DateTime.parse('2000-02-21T11:54:06Z'));
    expect(article.title,
        'First-principles calculations of hot-electron lifetimes in metals');
    expect(article.summary,
        'First-principles calculations of the inelastic lifetime of low-energy electrons in Al, Mg, Be, and Cu are reported.');
    expect(article.authors, ['I. Campillo', 'V. M. Silkin', 'J. M. Pitarke']);
    expect(article.doi, '10.1103/PhysRevB.61.13484');
    expect(article.doiUrl, 'http://dx.doi.org/10.1103/PhysRevB.61.13484');
    expect(article.comment, '8 pages, 10 figures, to appear in Phys. Rev. B');
    expect(article.journalRef, 'Phys. Rev. B 61, 13484 (2000)');
    expect(article.categories, ['cond-mat.mtrl-sci']);
    expect(article.articleUrl, 'http://arxiv.org/abs/cond-mat/0002322v1');
    expect(article.pdfUrl, 'http://arxiv.org/pdf/cond-mat/0002322v1');
  });

  test('Conversion from XML entry', () {
    final entryXml = '''<entry>
        <id>http://arxiv.org/abs/cond-mat/0002322v1</id>
        <updated>2000-02-21T11:53:06Z</updated>
        <published>2000-02-21T11:54:06Z</published>
        <title>First-principles calculations of hot-electron lifetimes in metals</title>
        <summary>First-principles calculations of the inelastic lifetime of low-energy electrons in Al, Mg, Be, and Cu are reported.</summary>
        <author>
            <name>I. Campillo</name>
        </author>
        <author>
            <name>V. M. Silkin</name>
        </author>
        <author>
            <name>J. M. Pitarke</name>
        </author>
        <arxiv:doi xmlns:arxiv="http://arxiv.org/schemas/atom">10.1103/PhysRevB.61.13484</arxiv:doi>
        <link title="doi" href="http://dx.doi.org/10.1103/PhysRevB.61.13484" rel="related"/>
        <arxiv:comment xmlns:arxiv="http://arxiv.org/schemas/atom">8 pages, 10 figures, to appear in Phys. Rev. B</arxiv:comment>
        <arxiv:journal_ref xmlns:arxiv="http://arxiv.org/schemas/atom">Phys. Rev. B 61, 13484 (2000)</arxiv:journal_ref>
        <link href="http://arxiv.org/abs/cond-mat/0002322v1" rel="alternate" type="text/html"/>
        <link title="pdf" href="http://arxiv.org/pdf/cond-mat/0002322v1" rel="related" type="application/pdf"/>
        <arxiv:primary_category xmlns:arxiv="http://arxiv.org/schemas/atom" term="cond-mat.mtrl-sci" scheme="http://arxiv.org/schemas/atom"/>
        <category term="cond-mat.mtrl-sci" scheme="http://arxiv.org/schemas/atom"/>
    </entry>''';

    final entry = xml.parse(entryXml).findElements('entry').first;
    final article = Article.fromEntry(entry);

    expect(article.id, 'cond-mat/0002322v1');
    expect(article.updated, DateTime.parse('2000-02-21T11:53:06Z'));
    expect(article.published, DateTime.parse('2000-02-21T11:54:06Z'));
    expect(article.title,
        'First-principles calculations of hot-electron lifetimes in metals');
    expect(article.summary,
        'First-principles calculations of the inelastic lifetime of low-energy electrons in Al, Mg, Be, and Cu are reported.');
    expect(article.authors, ['I. Campillo', 'V. M. Silkin', 'J. M. Pitarke']);
    expect(article.doi, '10.1103/PhysRevB.61.13484');
    expect(article.doiUrl, 'http://dx.doi.org/10.1103/PhysRevB.61.13484');
    expect(article.comment, '8 pages, 10 figures, to appear in Phys. Rev. B');
    expect(article.journalRef, 'Phys. Rev. B 61, 13484 (2000)');
    expect(article.categories, ['cond-mat.mtrl-sci']);
    expect(article.articleUrl, 'http://arxiv.org/abs/cond-mat/0002322v1');
    expect(article.pdfUrl, 'http://arxiv.org/pdf/cond-mat/0002322v1');
  });

  test('LaTex delimiter replacement', () {
    expect(replaceLaTeXDelims(r"$H_0$"), r"\(H_0\)");
    expect(replaceLaTeXDelims(r"$H_0$ foo"), r"\(H_0\) foo");
    expect(replaceLaTeXDelims(r"$H_0$ foo $H_1$"), r"\(H_0\) foo \(H_1\)");
    expect(replaceLaTeXDelims(r"$H_0$ $H_1$ bar"), r"\(H_0\) \(H_1\) bar");
    expect(replaceLaTeXDelims(r"$H_0$ foo $H_1$ bar"), r"\(H_0\) foo \(H_1\) bar");
  });
}
